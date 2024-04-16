load "../../gnuplot/style.gp"
load "../../gnuplot/style-cairo.gp"

set xlabel 'vlnová délka $\wavelen\,[\si{\nano\metre}]$'
set ylabel 'účinnost $\qeff$'
unset key;

set term cairolatex pdf size 8cm,6cm
set output "cameraeff.tex"
plot "../../data/pimax_1024.dat" u 1:2 w l
