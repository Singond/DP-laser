using Gnuplot

if !@isdefined calib_example
	include("calibration.jl")
end

if !isdir("results")
	mkdir("results")
end

tscale = 1e9

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	load '../gnuplot/style-splot.gp'
	set tmargin at screen 0.80
	set bmargin at screen 0.22
	set xrange [40:65]
	set zrange [-0.002:0.07]
	set ztics 0.01
	set xyplane at 0
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$' rotate parallel
	set ylabel 'číslo měření' rotate parallel
	set zlabel 'signál fotodiody \$\\ityfd\\,[\\si{\\volt}]\$'
	unset key
""" :-
for (k, x) in enumerate(singleshots[1:4:end])
	m = 1:4:length(x.fd[1])
	@gsp :- x.fd[1][m] * tscale k * ones(size(x.fd[2][m])) x.fd[2][m] "w l ls 1"
end
Gnuplot.save("results/pulse-compare.tex",
	term="cairolatex pdf size 12cm,8cm")
