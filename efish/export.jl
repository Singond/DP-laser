using Gnuplot

include("calibration.jl")

if !isdir("plots")
	mkdir("plots")
end

@gp """
	load '../style.gp'
	set key top left
	set xlabel 'intenzita elektrického pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set ylabel 'signál E-FISH \$\\efish\\,[\\si{\\arbunit}]\$'
	Eb = 5.9
	set arrow from Eb, graph 0 to Eb, graph 1 lc 'black' lw 2 dt 3 nohead
	set label "bez výboje" at 5.7,1 right
	set label "výboj" at 6.2,1 left
""" :-
@gp :- E./1e6 efish "w p ls 1 t 'naměřená data'" :-
E1 = LinRange(minimum(E), maximum(E), 100)
@gp :- E1./1e6 calib_example.calib(E1) "w l ls 1 dt 2 t 'model \$\\efish \\sim \\elfield^2\$'" :-
Gnuplot.save("plots/calib.tex", term="epslatex size 12cm,8cm")
#Gnuplot.save("plots/calib.tikz", term="tikz size 12cm,8cm")

include("main.jl")
@gp """
	load '../style.gp'
	set xyplane at 0
	set border 895
	set grid xtics vertical
	set grid ytics vertical
	set grid ztics
	set style fill solid 0.5
	set xlabel '\$\\tim\\,[\\si{\\micro\\second}]\$' offset 0,-1
	set xtics offset 0,-0.5
	set ylabel '\$y\\,[\\si{\\milli\\metre}]\$' offset 0,-1
	set zlabel '\$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$' rotate by 90
	unset key
"""
for k in [8:-1:1; 10:13]
	x = X[k]
	t = x.t .- x.t[1]
	yy = ones(size(x.t)) * y[k]
	zz = zeros(size(x.t))
	@gsp :- t yy x.E./1e6 zz x.E./1e6 "w zerrorfill ls 1" :-
end
Gnuplot.save("plots/period-elfield.tex", term="epslatex size 12cm,8cm")
#Gnuplot.save("plots/period-elfield.tikz", term="tikz size 12cm,8cm")
