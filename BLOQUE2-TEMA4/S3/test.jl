# imports
using DSP
using FFTW
using WAV
using Plots
using ToeplitzMatrices
using StatsBase
using LinearAlgebra

plotlyjs()

function coeficientes_prediccion_lineal(sw, orden)
  r = crosscov(sw, sw)
  R = Toeplitz(r[1:orden],  r[1:orden])
  a = R \ r[2:orden+1]
  return a
end

function error_prediccion(sw, orden)
  # Obtén los coeficientes de predicción lineal
  a = coeficientes_prediccion_lineal(sw, orden)
  
  # Filtro FIR inverso
  b = [1.0, -a']  # Los coeficientes son [1, -a[1], -a[2], ..., -a[p]]
  
  # Filtra la trama original
  print("this is b")
  println(b)
  error = DSP.conv(b[2], sw)
  
  return error
end

sw = confront[5800:6200]
orden = 10

error = error_prediccion(sw, orden)