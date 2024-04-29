using Printf

using Gnuplot

if !@isdefined Xcorr
	include("energy.jl")
end

if !isdir("results")
	mkdir("results")
end

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [-0.2:6.2]
	set yrange [-0.05:1.25]
	set xlabel '\$max(\\efish)\\,[\\si{\\arbunit}]\$'
	set ylabel '\$\\int\\efish\\dd{t}\\,[\\si{\\arbunit}]\$' #offset -0.5,0
	unset key
""" :-
@gp :- efish_peak efish_int*1e9 "w p"
Gnuplot.save("results/intmax.tex",
	term="cairolatex pdf size 12cm,8cm")
