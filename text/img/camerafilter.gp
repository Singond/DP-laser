load "../../gnuplot/style.gp"
load "../../gnuplot/style-cairo.gp"

set xlabel 'vlnová délka $\wavelen\,[\si{\nano\metre}]$'
set ylabel 'propustnost $\transmittance$'
set key bottom right

set term cairolatex pdf size 8cm,6cm
set output "camerafilter.tex"
plot "../../lif/data-common/sklo1_filtrSe.dat" u 1:2 w l t '1.~sklo', \
	"../../lif/data-common/sklo2_filtrSe.dat" u 1:2 w l t '2.~sklo'
