using Gnuplot

if !@isdefined calib_example
	include("calibration.jl")
end

if !isdir("results")
	mkdir("results")
end

tscale = 1e9

# Singleshots
@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [38:]
	set y2range [-0.004:]
	set ytics in nomirror
	set y2tics in nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$' tc ls 1
	set y2label 'intenzita \$\\enlaser\\,[\\si{\\arbunit}]\$' tc ls 2
	set key center right
""" :-
frame = singleshots[1]
@gp :- frame.efish[1] * tscale frame.efish[2] "w l t '\\EFISH{} \$\\efish\$'" :-
@gp :- frame.fd[1] * tscale frame.fd[2] "w l axes x1y2 t 'energie laseru \$\\enlaser\$'"
Gnuplot.save("results/singleshot.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [48:52]
	set xtics 1
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$'
	set key bottom right
"""
for k in 1:9:length(singleshots)
	@gp :- singleshots[k].efish[1] * tscale singleshots[k].efish[2] "w l t '$k'"
end
Gnuplot.save("results/singleshots-compare.tex",
	term="cairolatex pdf size 12cm,8cm")
