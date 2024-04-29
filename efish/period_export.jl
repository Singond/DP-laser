using Printf

using Gnuplot

if !@isdefined calib_mid1
	include("main.jl")
end

if !isdir("results")
	mkdir("results")
end

Escale = 1e-6

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set xrange [-0.2:]
	set yrange [-0.1:]
	set xlabel 'intenzita elektrického pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$'
	set key top left Left reverse samplen 2 width 1 height 1
"""
E = LinRange(0, 3.8e6, 100)
@gp :- calib_mid1.E * Escale calib_mid1.Iefish "w p ls 1 t 'střed 1 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid1.model.(E) "w l ls 1 notitle"
@gp :- calib_bot.E * Escale calib_bot.Iefish "w p ls 2 t 'spodek (\\SI{-0.35}{\\milli\\metre})'"
@gp :- E * Escale calib_bot.model.(E) "w l ls 2 notitle"
@gp :- calib_mid2.E * Escale calib_mid2.Iefish "w p ls 3 t 'střed 2 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid2.model.(E) "w l ls 3 notitle"
Gnuplot.save("results/period-calib.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set yrange [-0.1:]
	set xlabel 'intenzita elektrického pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$'
	set key top center Left reverse samplen 2 height 1
"""
E = LinRange(-4.7e6, 3.8e6, 100)
@gp :- calib_mid1.E * Escale calib_mid1.Iefish "w p ls 1 t 'střed 1 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid1.model.(E) "w l ls 1 notitle"
@gp :- [-calib_mid1.model_params[2]] * Escale [0] "w p ls 1 pt 6 ps 1 notitle"
@gp :- calib_bot.E * Escale calib_bot.Iefish "w p ls 2 t 'spodek (\\SI{-0.35}{\\milli\\metre})'"
@gp :- E * Escale calib_bot.model.(E) "w l ls 2 notitle"
@gp :- [-calib_bot.model_params[2]] * Escale [0] "w p ls 2 pt 6 ps 1 notitle"
@gp :- calib_mid2.E * Escale calib_mid2.Iefish "w p ls 3 t 'střed 2 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid2.model.(E) "w l ls 3 notitle"
@gp :- [-calib_mid2.model_params[2]] * Escale [0] "w p ls 3 pt 6 ps 1 notitle"
Gnuplot.save("results/period-calib-bilateral.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set ytics 0.2
	set xlabel 'poloha \$\\ypos\\,[\\si{\\milli\\metre}]\$'
	set ylabel 'amplituda \$\\efish\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set key bottom left Left reverse samplen 2 height 1
"""
@gp :- y  Imax * Escale "w p ps 1 t '\$\\max(\\efish)\$'"
@gp :- y -Imin * Escale "w p ps 1.4 t '\$|\\min(\\efish)|\$'"
Gnuplot.save("results/period-amplitude.tex",
	term="cairolatex pdf size 12cm,8cm")
