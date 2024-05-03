using Gnuplot

if !@isdefined calib_example
	include("calibration.jl")
end

if !isdir("plots")
	mkdir("plots")
end

# Calibration
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
