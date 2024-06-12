load "../../gnuplot/style.gp"
load "../../gnuplot/style-cairo.gp"

set style arrow 1 size character 1,15,60 filled

set term cairolatex pdf size 5cm,5cm
set output "polarization.tex"
set border 0
set xzeroaxis lt -1
set yzeroaxis lt -1
unset xtics
unset ytics
set xrange [-2.2:4.5]
set yrange [-2.5:8]
set arrow 1 from -2.2,0 to 4.5,0 as 1
set arrow 2 from 0,-2.5 to 0,8 as 1
set label 1 '$\elfield$' at first 4,-1 right
set label 2 '$\epol$' at first -0.3,7 right
unset key
a = 0.2
b = 1
c = 0
plot sample [-2:4] a * x**2 + b * x + c w l ls 1, \
	[-2:4] b * x w l ls 1 dt 2
