# Objetivo
# Familiarizarse y profundizar en algunos de los apartados de 4.1 Introducción al Procesado de Audio. Actividades

# dependencies

using Plots
using WAV
using Sound

# 1. Genere una onda sinusoidal de duración 1s., amplitud 𝐴 = 1 y frecuencia de fs 𝑓 = !
# 1000𝐻𝑧. Varíe la frecuencia fundamental del tono 𝑓 = [100, 200, 300]𝐻𝑧 y reproduzca los
# comandos usando una primitiva adecuada en Julia.

# Parámetros de la onda sinusoidal
amplitud = 1.0      # Amplitud de la onda
frecuencia = 100.0    # Frecuencia de la onda en Hz
fase = 0.0          # Fase inicial de la onda
duracion = 5.0      # Duración de la señal en segundos
fs = 1000     # Número de puntos de fs por segundo

# Crear vector de tiempo
t = 0:1/fs:duracion

# Generar la onda sinusoidal
y = amplitud * sin.(2π * frecuencia * t)

# Graficar la onda sinusoidal
plot(t, y, label="Onda Sinusoidal", xlabel="Tiempo (s)", ylabel="Amplitud", legend=:top)
sound(y, fs)
# variamos la frecuencia central

frecs = [100, 200, 300]

# Create a layout with the specified number of subplots
layout = @layout [1:size(frecs,2)]

# Create a plot with the specified layout
p = plot(layout=layout)

# Loop through each subplot and plot the corresponding data
for f0 in frecs
  y_loop = amplitud * sin.(2π * f0 * t)
  plot!(p, x, y_loop, subplot=f0, label="Set $f0")
end


# Display the final plot
display(p)

# f2 = 100
# y2 = amplitud * sin.(2π * f2 * t)
# plot(t, y2, label="Onda Sinusoidal", xlabel="Tiempo (s)", ylabel="Amplitud", legend=:top)



# 2. Represente la onda sinusoidal del punto 1 para f0 = [5, 10] Hz, compruebe gráficamente el valor del periodo (T0). Represente también el módulo de la FFT y compruebe el valor de f0.
# 3. Represente el módulo de la FFT de la señal ejemploEj3T4.mat que fue muestreada a fs = 11000 Hz, identifique f0 y y las frecuencias formantes.
# Prácticas Consejo: Puede usar una librería como MAT.jl para leer matrices de MatLab.
# 4. Represente en el dominio temporal y en el dominio espectral los fragmentos de una señal de voz contenidos en ejemploEj4AT4.mat y ejemploEj4BT4.mat. Identifique qué fragmento es sonoro y qué fragmento es sordo (fs = 11000 Hz).
