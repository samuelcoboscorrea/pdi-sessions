using Plots

vent_rect = ones(256)  # Ventana rectangular con longitud 256
vent_hamm = hamming(22)  # Ventana de Hamming con longitud 22

NFFT = 256  # Longitud deseada para la FFT

Rect_Frec = fft(vent_rect, NFFT)
Hamm_Frec = fft(vent_hamm, NFFT)

fs = 1  # Frecuencia de muestreo, puede ajustarse según tus necesidades

ejex = fs * range(0, stop=1, length=NFFT)

# Graficar ventana rectangular
plot_rect = plot(ejex[1:div(NFFT, 2)], 20 * log10.(abs.(Rect_Frec[1:div(NFFT, 2)])),
    title="Lóbulos de la Ventana Rectangular", xlabel="Hz/fs", ylabel="Amplitud(dB)", legend=false)

# Graficar ventana de Hamming
plot_hamm = plot(ejex[1:div(NFFT, 2)], 20 * log10.(abs.(Hamm_Frec[1:div(NFFT, 2)])),
    title="Lóbulos de la Ventana de Hamming", xlabel="Hz/fs", ylabel="Amplitud(dB)", legend=false)

# Mostrar ambas gráficas en una sola figura
plot(plot_rect, plot_hamm, layout=(2, 1))
