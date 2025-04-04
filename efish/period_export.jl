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
@gp :- calib_mid2.E * Escale calib_mid2.Iefish "w p ls 2 t 'střed 2 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid2.model.(E) "w l ls 2 notitle"
@gp :- calib_bot.E * Escale calib_bot.Iefish "w p ls 3 t 'spodek (\\SI{-0.35}{\\milli\\metre})'"
@gp :- E * Escale calib_bot.model.(E) "w l ls 3 notitle"
Gnuplot.save("results/period-calib.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set yrange [-0.1:]
	set xlabel 'intenzita elektrického pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set ylabel 'intenzita \$\\efish\\,[\\si{\\arbunit}]\$'
	set label '\$\\efish(\\elfield) \\propto \\efishmult (\\elfield + \\efishshift)^2\$' center at graph 0.5,0.5
	set key top center Left reverse samplen 2 height 1
"""
E = LinRange(-4.7e6, 3.8e6, 100)
@gp :- calib_mid1.E * Escale calib_mid1.Iefish "w p ls 1 t 'střed 1 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid1.model.(E) "w l ls 1 notitle"
@gp :- [-calib_mid1.model_params[2]] * Escale [0] "w p ls 1 pt 6 ps 1 notitle"
@gp :- calib_mid2.E * Escale calib_mid2.Iefish "w p ls 2 t 'střed 2 (\\SI{0}{\\milli\\metre})'"
@gp :- E * Escale calib_mid2.model.(E) "w l ls 2 notitle"
@gp :- [-calib_mid2.model_params[2]] * Escale [0] "w p ls 2 pt 6 ps 1 notitle"
@gp :- calib_bot.E * Escale calib_bot.Iefish "w p ls 3 t 'spodek (\\SI{-0.35}{\\milli\\metre})'"
@gp :- E * Escale calib_bot.model.(E) "w l ls 3 notitle"
@gp :- [-calib_bot.model_params[2]] * Escale [0] "w p ls 3 pt 6 ps 1 notitle"
Gnuplot.save("results/period-calib-bilateral.tex",
	term="cairolatex pdf size 12cm,8cm")
Gnuplot.save("results/period-calib-bilateral-small.tex",
	term="cairolatex pdf size 10.5cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	set ytics 0.2
	set xlabel 'poloha \$\\ypos\\,[\\si{\\milli\\metre}]\$'
	set ylabel 'amplituda \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set key bottom left Left reverse samplen 2 height 1
"""
@gp :- y  Imax * Escale "w p ps 1 t '\$\\max(\\efish)\$'"
@gp :- y -Imin * Escale "w p ps 1.4 t '\$|\\min(\\efish)|\$'"
Gnuplot.save("results/period-amplitude.tex",
	term="cairolatex pdf size 12cm,8cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	load '../gnuplot/style-splot.gp'
	set tmargin at screen 0.82
	set bmargin at screen 0.22
	set rmargin at screen 0.84
	set lmargin at screen 0.23
	set style fill transparent solid 0.2
	set xtics 20
	set ytics 0.4
	set xyplane at 0
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$' offset -0.5,0
	set ylabel 'poloha \$y\\,[\\si{\\milli\\metre}]\$'
	set zlabel 'signál \$\\efish\\,[\\si{\\arbunit}]\$'
	unset key
"""
for x in X
	t = x.t .- x.t[1]
	yy = x.y * ones(size(x.t))
	zz = zeros(size(x.t))
	@gsp :- t yy x.Iefish zz x.Iefish "w zerrorfill ls 1"
	@gsp :- t yy x.Iefish "w l ls 1"
end
Gnuplot.save("results/period-efish.tex",
	term="cairolatex pdf size 12.5cm,8cm")

gp_narrow = """
	set lmargin at screen 0.28
	set xlabel '\$\\tim\\,[\\si{\\micro\\second}]\$' offset -1,0
	set ylabel '\$y\\,[\\si{\\milli\\metre}]\$' offset -2,0
"""
@gp :- gp_narrow """
	set zrange noextend
""" :-
Gnuplot.save("results/period-efish-narrow.tex",
	term="cairolatex pdf size 5.4cm,5cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	load '../gnuplot/style-splot.gp'
	set tmargin at screen 0.82
	set bmargin at screen 0.22
	set rmargin at screen 0.84
	set lmargin at screen 0.23
	set style fill transparent solid 0.2
	set xyplane at -3.5
	set zrange [-3.5:3.5]
	set xtics 20 offset 0,-0.5
	set ytics 0.4 offset 0.5,0
	set ztics
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$' offset 0,-1
	set ylabel 'poloha \$y\\,[\\si{\\milli\\metre}]\$' offset 0,-1
	set zlabel 'el. pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$' rotate by 90
	set label '\$\\dbdvoltage\\,[\\times\\SI{3}{\\kilo\\volt}]\$' at 2,0.8,2.7 tc ls 4
	set label '\$\\dbdcurrent\\,[\\si{\\milli\\ampere}]\$' at 42,0.8,2.5 tc ls 2
	unset key
"""
Uscale = 1/3e3
Iscale = 1e3
x = X[1]
@gsp :- x.t .- x.t[1] ones(size(x.t)) * 0.8 x.Um * Uscale "w l ls 4 lw 4"
@gsp :- x.t .- x.t[1] ones(size(x.t)) * 0.8 x.Im * Iscale "w l ls 2 lw 4"
for k in [8:-1:1; 10:13]
	local x = X[k]
	t = x.t .- x.t[1]
	yy = ones(size(x.t)) * y[k]
	zz = zeros(size(x.t))
	@gsp :- t yy x.E./1e6 zz x.E./1e6 "w zerrorfill ls 1" :-
	@gsp :- t yy x.E./1e6 zz x.E./1e6 "w l ls 1" :-
end
Gnuplot.save("results/period-elfield.tex",
	term="cairolatex colourtext pdf size 12.5cm,10cm")

@gp :- """
	set lmargin at screen 0.28
	set xlabel offset -1,0
	set ylabel offset -1,0
""" :-
Gnuplot.save("results/period-elfield-small.tex",
	term="cairolatex colourtext pdf size 10cm,7cm")

@gp :- gp_narrow :-
Gnuplot.save("results/period-elfield-narrow.tex",
	term="cairolatex colourtext pdf size 5.4cm,5cm")

@gp """
	load '../gnuplot/style.gp'
	load '../gnuplot/style-cairo.gp'
	#set tmargin at screen 0.82
	#set bmargin at screen 0.22
	#set rmargin at screen 0.84
	#set lmargin at screen 0.23
	set ytics nomirror
	set xlabel 'čas \$\\tim\\,[\\si{\\micro\\second}]\$'
	set ylabel 'el. pole \$\\elfield\\,[\\si{\\mega\\volt\\per\\metre}]\$'
	set cblabel '\$y\\,[\\si{\\milli\\metre}]\$' offset 0,0
	set label '\$\\dbdvoltage\\,[\\SI{e4}{\\volt}]\$' center at 45,-1.3 tc ls 1
	set label '\$\\dbdcurrent\\,[\\si{\\milli\\ampere}]\$' at 40,3 tc ls 2
	unset key
"""
# for x in X[[8:-1:1; 10:13]]
for x in X
	t = x.t .- x.t[1]
	color = x.y * ones(size(t))
	@gp :- t x.E.*1e-6 color "w l lc palette" :-
end
Uscale = 1e-4
Iscale = 1e3
x = X[1]
@gp :- x.t .- x.t[1] x.Um * Uscale "w l axes x1y1 ls 1" :-
@gp :- x.t .- x.t[1] x.Im * Iscale "w l axes x1y1 ls 2" :-
Gnuplot.save("results/period-elfield-2d-small.tex",
	term="cairolatex colourtext pdf size 10.8cm,7cm")
