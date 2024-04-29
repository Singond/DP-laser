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
	set xrange [40:70]
	set ztics 0.05
	set xyplane at 0
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$' rotate parallel
	set ylabel 'číslo měření' rotate parallel
	set zlabel 'signál fotodiody \$\\ityfd\\,[\\si{\\arbunit}]\$'
	unset key
""" :-
for (k, x) in enumerate(calibration[1:1:end])
	@gsp :- x.fd[1] * tscale k * ones(size(x.fd[2])) x.fd[2] "w l ls 1"
end
Gnuplot.save("results/pulse-compare.tex",
	term="cairolatex pdf size 12cm,8cm")
