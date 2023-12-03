using FFTW
using Plots

function calcular_pitch_espectro(signal, fs)
    # Calcula la FFT de la señal
    fft_result = fft(signal)

    # Calcula la magnitud del espectro
    espectro_magnitud = abs.(fft_result)

    # Encuentra el valor máximo y la posición del máximo en el espectro
    maximo, indice_maximo = findmax(espectro_magnitud)

    # Calcula el pitch como la frecuencia correspondiente al índice máximo
    pitch = fs * (indice_maximo - 1) / length(signal)

    return pitch, espectro_magnitud
end

# Ejemplo de uso:
fs = 1000  # Frecuencia de muestreo en Hz
t = 0:1/fs:0.02  # Vector de tiempo
frecuencia_pitch = 100  # Frecuencia fundamental de la señal
signal = sin.(2π * frecuencia_pitch * t)

pitch_estimado, espectro_magnitud = calcular_pitch_espectro(signal, fs)

println("El pitch estimado es: ", pitch_estimado, " Hz")

# Grafica el espectro de magnitud
frequencies = fftfreq(length(signal), 1/fs)
plot(frequencies, espectro_magnitud, xlabel="Frecuencia (Hz)", ylabel="Magnitud del Espectro", label="Espectro Magnitud")
scatter!([pitch_estimado], [maximum(espectro_magnitud)], label="Pitch Estimado", color="red")
