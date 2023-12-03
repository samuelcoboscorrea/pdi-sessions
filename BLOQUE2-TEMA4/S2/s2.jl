using Plots
using WAV
using Sound

# Parámetros de la onda sinusoidal
amplitud = 1.0      # Amplitud de la onda
fase = 0.0          # Fase inicial de la onda
duracion = 5.0      # Duración de la señal en segundos
fs = 1000           # Número de puntos de fs por segundo

# Crear vector de tiempo
t = 0:1/fs:duracion

# Frecuencias a variar
frecs = [100, 200, 300]

# Crear un plot con subplots
p = plot(layout=(length(frecs), 1))

# Loop a través de cada frecuencia y graficar la onda correspondiente
for (i, f0) in enumerate(frecs)
    y_loop = amplitud * sin.(2π * f0 * t)
    plot!(p, t, y_loop, label="Set $f0", subplot=i)
end

# Mostrar el gráfico final
display(p)

# Reproducir la onda sinusoidal con la última frecuencia
sound(y_loop, fs)
