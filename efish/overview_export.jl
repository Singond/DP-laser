using Gnuplot

if !@isdefined calib_example
	include("calibration.jl")
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
	#set xrange [38:]
	set yrange [-6.5:6.5]
	set y2range [-2:2]
	set ytics in nomirror
	set y2tics 1 in nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$'
	set ylabel 'napětí \$\\dbdvoltage\\,[\\si{\\volt}]\$' tc ls 1
	set y2label 'proud \$\\dbdcurrent\\,[\\si{\\ampere}]\$' tc ls 2
	unset key
""" :-
frame = overviews[1]
t0 = frame.U[1][1]
@gp :- (frame.U[1][1:100:end] .- t0) * tscale frame.U[2][1:100:end] * uscale "w l " :-
@gp :- (frame.I[1][1:100:end] .- t0) * tscale frame.I[2][1:100:end] * iscale "w l axes x1y2 " :-
Gnuplot.save("results/overview-full.tex",
	term="cairolatex pdf colourtext size 12.5cm,5cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [0:9.09e1]
	set ytics in nomirror
	set y2tics in nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$'
	set ylabel 'napětí \$\\dbdvoltage\\,[\\si{\\volt}]\$' tc ls 1
	set y2label 'proud \$\\dbdcurrent\\,[\\si{\\ampere}]\$' tc ls 2
	unset key
""" :-
m = 489863:1397891
t0 = frame.U[1][m][1]
@gp :- (frame.U[1][m] .- t0) * tscale frame.U[2][m] * uscale "w l" :-
@gp :- (frame.I[1][m] .- t0) * tscale frame.I[2][m] * iscale "w l axes x1y2" :-
Gnuplot.save("results/overview-period.tex",
	term="cairolatex pdf size 12cm,8cm")
