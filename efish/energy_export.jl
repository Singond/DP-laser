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
	set rmargin at screen 0.84
	set xrange [48.5:51]
	set cbtics 1
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$' offset -0.5,0
	set cblabel 'energie pulzu \$\\enlaser\\,[\\si{\\milli\\joule}]\$' offset 2,0
	unset key
"""
for x in Xcorr
	label = @sprintf("%.2f mJ", x.Epulse*1e3)
	color = x.Epulse * 1e3 * ones(size(x.efish[1]))
	@gp :- x.efish[1].*1e9 x.efish[2] color "w l lc palette t '$label'" :-
end
Gnuplot.save("results/energy-corrected.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set rmargin at screen 0.84
	set xrange [48.5:51]
	set cbtics 1
	set xlabel 'čas \$\\tim\\,[\\si{\\nano\\second}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$' offset -0.5,0
	set cblabel 'energie pulzu \$\\enlaser\\,[\\si{\\milli\\joule}]\$' offset 2,0
	unset key
"""
for x in Xcorr
	label = @sprintf("%.2f mJ", x.Epulse*1e3)
	color = x.Epulse * 1e3 * ones(size(x.efish[1]))
	efish_norm = x.efish[2]./x.efish_peak
	@gp :- x.efish[1].*1e9 efish_norm color "w l lc palette t '$label'" :-
end
Gnuplot.save("results/energy-norm.tex",
	term="cairolatex pdf size 12cm,8cm")
