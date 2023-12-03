using Plots, DSP, FFTW
gr()

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


N = 20
h_window = DSP.hamming(N)

fs = 100
f = digitalfilter(Lowpass(5, fs = fs), FIRWindow(h_window))
w = range(0, stop=pi, length=N)
h = FIRfreqz(f, w)


h_db = log10.(abs.(h))
ws = w/pi*(fs/2)
plot(ws, h_db, xlabel = "Frequency (Hz)", ylabel = "Magnitude (db)")