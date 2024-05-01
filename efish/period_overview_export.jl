using Gnuplot

if !@isdefined calib_example
	include("main.jl")
end

if !isdir("results")
	mkdir("results")
end

tscale = 1e6
uscale = 1e-3
iscale = 1e3

# Overview
@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set rmargin at screen 0.9
	set yrange [-8:8]
	set y2range [-4:4]
	set ytics  4 in nomirror
	set y2tics 2 in nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$'
	set ylabel 'napětí \$\\dbdvoltage\\,[\\si{\\kilo\\volt}]\$' tc ls 1
	set y2label 'proud \$\\dbdcurrent\\,[\\si{\\milli\\ampere}]\$' tc ls 2
	unset key
""" :-
frame = period_overviews[1]
t0 = frame.U[1][1]
m = 1:5:length(frame.U[1])
@gp :- (frame.U[1][m] .- t0) * tscale frame.U[2][m] * uscale "w l " :-
@gp :- (frame.I[1][m] .- t0) * tscale frame.I[2][m] * iscale "w l axes x1y2 " :-
Gnuplot.save("results/period-overview-full.tex",
	term="cairolatex pdf colourtext size 12.5cm,4cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [0:9.09e1]
	set yrange [-7.5:7.5]
	set y2range [-3.5:3.5]
	set ytics in nomirror
	set y2tics in nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$'
	set ylabel 'napětí \$\\dbdvoltage\\,[\\si{\\kilo\\volt}]\$' tc ls 1
	set y2label 'proud \$\\dbdcurrent\\,[\\si{\\milli\\ampere}]\$' tc ls 2
	unset key
""" :-
m = 44308:1:53402
t0 = frame.U[1][m][1]
@gp :- (frame.U[1][m] .- t0) * tscale frame.U[2][m] * uscale "w l" :-
@gp :- (frame.I[1][m] .- t0) * tscale frame.I[2][m] * iscale "w l axes x1y2" :-
Gnuplot.save("results/period-overview-period.tex",
	term="cairolatex pdf size 12cm,8cm")
