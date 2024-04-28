using Gnuplot

if !@isdefined calib_example
	include("calibration.jl")
end

if !isdir("plots")
	mkdir("plots")
end

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set key top left
	set offsets graph 0.05, graph 0.05, graph 0.05, graph 0.05
	set xrange noextend
	set yrange noextend
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
Gnuplot.save("plots/calib.tex", term="cairolatex pdf size 12cm,8cm")
#Gnuplot.save("plots/calib.tikz", term="tikz size 12cm,8cm")

if !@isdefined X
	include("main.jl")
end

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set style fill transparent solid 0.2
	set xyplane at -4
	set border 895
	set grid xtics vertical
	set grid ytics vertical
	set grid ztics
	set xtics 20 offset 0,-0.5
	set ytics 0.4 offset 0.5,0
	set ztics
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$' offset 0,-1
	set ylabel 'poloha \$y\\,[\\si{\\milli\\metre}]\$' offset 0,-1
	set zlabel 'el. pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$' rotate by 90
	set rmargin at screen 1
	unset key
"""
for k in [8:-1:1; 10:13]
	local x = X[k]
	t = x.t .- x.t[1]
	yy = ones(size(x.t)) * y[k]
	zz = zeros(size(x.t))
	@gsp :- t yy x.E./1e6 zz x.E./1e6 "w zerrorfill ls 1" :-
	@gsp :- t yy x.E./1e6 zz x.E./1e6 "w l ls 1" :-
end
Gnuplot.save("plots/period-elfield.tex",
	term="cairolatex color pdf size 14cm,12cm")
#Gnuplot.save("plots/period-elfield.tikz",
#	term="tikz tightboundingbox size 14cm,12cm")
