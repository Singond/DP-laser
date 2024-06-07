load "../../gnuplot/style.gp"
load "../../gnuplot/style-cairo.gp"

set term cairolatex pdf size 5cm,5cm
set output "polarization.tex"
set border 0
set xzeroaxis lt -1
set yzeroaxis lt -1
unset xtics
unset ytics
set xlabel '$\elfield$'
set ylabel '$\polarization$'
set xrange [-2:4]
set yrange noextend
unset key
a = 0.2
b = 1
c = 0
plot a * x**2 + b * x + c w l ls 1, \
	b * x w l ls 1 dt 2
