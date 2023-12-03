# file to store functions
using Plots
using Plots, DSP
gr()
plotlyjs()

function hamming_window(N)
  window = zeros(N)
  for n in 1:N
      window[n] = 0.54 - 0.46 * cos(2π * (n - 1) / (N - 1))
  end
  return window
end

function nextpow22(n)
  power = 0
  while 2^power < n
      power += 1
  end
  return power
end

function nextpow2(n)
  return ceil(Int, log2(ceil(n)))
end

function espectra_hamming(h_window)
  NFFT = 8*2^nextpow2(length(h_window));
  Hamm_Frec = fft(h_window, 200);

  plot(ejex[1:div(end, 2)], 20 * log10.(abs.(Hamm_Frec[1:div(end, 2)]) / maximum(abs.(Hamm_Frec[1:div(end, 2)]))), xlabel="Hz/fs", ylabel="Amplitud (dB)", title="Hamming", legend=false)

end

function espectro_ventanas(vent_rect, vent_hamm)
  NFFT = 8 * 2 ^ nextpow2(length(vent_rect))
  Rect_Frec = fft(vent_rect, NFFT)
  Hamm_Frec = fft(vent_hamm, NFFT)

  ejex = linspace(0, 1, length(Rect_Frec))

  # Graficar ventana rectangular
  plot_rect = plot(ejex[1:div(length(Rect_Frec), 2)], 20 * log.(abs.(Rect_Frec[1:div(length(Rect_Frec), 2)]) / maximum(abs.(Rect_Frec[1:div(length(Rect_Frec), 2)]))))
  title!("Rectangular")
  axis("tight")
  ylabel!("Amplitud(dB)")
  xlabel!("Hz/fs")

  # Graficar ventana de Hamming
  plot_hamm = plot(ejex[1:div(length(Hamm_Frec), 2)], 20 * log.(abs.(Hamm_Frec[1:div(length(Hamm_Frec), 2)]) / maximum(abs.(Hamm_Frec[1:div(length(Hamm_Frec), 2)]))))
  title!("Hamming")
  axis("tight")
  ylabel!("Amplitud(dB)")
  xlabel!("Hz/fs")

  # Mostrar ambas gráficas en una sola figura
  plot(plot_rect, plot_hamm, layout=(2,1))
end

 
function FIRfreqz(b::Array, w = range(0, stop=π, length=1024))
  n = length(w)
  h = Array{ComplexF32}(undef, n)
  sw = 0
  for i = 1:n
    for j = 1:length(b)
      sw += b[j]*exp(-im*w[i])^-j
    end
    h[i] = sw
    sw = 0
  end
  return h
end

function energia(s,h)

  # h - ventana de hamming
  # s - segmento de la señal
  # E = energia(s, h)
  Lt = length(s) - length(h)
  E = zeros(Lt)

  for n in 1:Lt
    E[n] = sum((s[1+n:length(h)+n] .* h).^2)
  end

  layout = plot(layout=(2, 1))

  # Gráfico
  plot!(layout, s, title="Señal s", xlabel="Muestras", ylabel="s", legend=false, subplot=1)
  plot!(layout, E, title="Energía", xlabel="Muestras", ylabel="E", legend=false, subplot=2)
end

function zcr(s, L)
  # calcula la tasa de cruces por cero, de la señal s, en tramas de L longitud

  Zcr = zeros(length(s) - L + 1)

  for n in 2:length(s) - L
    Zcr[n] = sum(0.5 / L * abs.(sign.(s[1 + n:L + n]) - sign.(s[n:L + n - 1])))
  end

  Zcr[1] = Zcr[2]

  return Zcr
end

function vozSS(s, h)
  s = s .- sum(s) / length(s)
  E = energia(s, h)
  Zcr = zcr(s, length(h))

  plot1 = plot(s[1:length(s) - length(h)], title="Señal de voz", legend=false)
  plot2 = plot(E, title="Energía", legend=false)
  plot3 = plot(Zcr, title="Cruces por cero", legend=false)
  
  plot(plot1, plot2, plot3, layout=(3,1), size=(800,600))
end

function autocorrelacion_entre_senales(trama1, trama2)
  # Calcular la autocorrelación
  c, k = xcorr(trama1, trama2)

  # Visualizar los resultados
  plot(k, c, xlabel="Desplazamiento", ylabel="Autocorrelación", legend=false)

  # Determinar si son tramas sonoras o sordas
  umbral_sonoro = 0.5
  es_sonoro = maximum(c) > umbral_sonoro

  if es_sonoro
      println("Las tramas son sonoras.")
      
      # Estimar el pitch o frecuencia fundamental
      indice_max = argmax(c)
      pitch = 1 / k[indice_max]  # Fórmula para el pitch
      println("Estimación del pitch: ", pitch, " Hz")
  else
      println("Las tramas son sordas.")
  end

  return c, k
end

function estimate_pitch(signal)
  autocorrelation = xcorr(signal, signal)
  
  # Find the index of the maximum autocorrelation
  maxIndex = argmax(autocorrelation)
  
  # Find the next peak after the maximum
  nextPeakIndex = argmax(autocorrelation[maxIndex+1:end])
  nextPeakIndex += maxIndex
  
  # Calculate the pitch in Hertz
  pitch = 1 / (nextPeakIndex - maxIndex)
  
  return pitch, autocorrelation
end

function spectrum(trama, fs)
  y_fft = fft(trama)
  y_fft_modulo = abs.(y_fft)
  n = length(trama)
  frequencies = fftfreq(n, fs)

  # Filtrar solo las frecuencias no negativas
  positive_frequencies_mask = frequencies .>= 0
  positive_frequencies = frequencies[positive_frequencies_mask]
  y_fft_modulo_positive = y_fft_modulo[positive_frequencies_mask]

  plot(positive_frequencies, y_fft_modulo_positive, xlabel="Frequency (Hz)", ylabel="|FFT|", label="FFT Module", legend=:topright, hover=positive_frequencies)
end

function estimar_pitch(autocorrelacion, fs)
  # Encuentra el índice del máximo en la autocorrelación
  indice_maximo = argmax(autocorrelacion)

  # Calcula el pitch como la inversa de la frecuencia correspondiente al índice máximo
  pitch = fs / indice_maximo

  return pitch
end

## ejercicio 5 funciones

function spectrogram(s, N, fs)
  espectrograma_y = DSP.spectrogram(vec(s), N, fs=fs)
  print(espectrograma_y)
  p = heatmap(espectrograma_y.time, espectrograma_y.freq, pow2db.(espectrograma_y.power))
  return p
end

function plot_spectrogram(p, title, xlabel, ylabel, plot_title)
  t = 1:size(p, 2)
  f = 1:size(p, 1)
  
  surf(t, f, 20 * log10.(abs.(p)), edgecolor="none")
  
  # Ajustes gráficos
  axis("xy")
  axis("tight")
  colormap(:jet)
  view(0, 90)
  
  title(title)
  xlabel(xlabel)
  ylabel(ylabel)
  
  # Mostrar la barra de colores
  colorbar(label="Amplitud (dB)")
end
