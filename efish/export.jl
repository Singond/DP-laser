using Gnuplot

include("calib.jl")

if !isdir("plots")
	mkdir("plots")
end

@gp """
	load '../style.gp'
	set key top left
	set xlabel 'intenzita elektrického pole \$\\elfield\\,[\\si{\\kilo\\volt\\per\\metre}]\$'
	set ylabel 'signál E-FISH \$\\efish\\,[\\si{\\arbunit}]\$'
	Eb = 2.4
	set arrow from Eb, graph 0 to Eb, graph 1 lc 'black' lw 2 dt 3 nohead
	set label "bez výboje" at 2.3,1 right
	set label "výboj" at 2.5,1 left
""" :-
@gp :- E./1e3 efish "w p ls 1 t 'naměřená data'" :-
E1 = LinRange(minimum(E), maximum(E), 100)
@gp :- E1./1e3 calib(E1) "w l ls 1 dt 2 t 'model \$\\efish \\sim \\elfield^2\$'" :-
save(term="epslatex size 12cm,8cm", output="plots/calib.tex")

include("main.jl")
@gp """
	load '../style.gp'
	set xyplane at 0
	set xlabel '\$\\tim\\,[\\si{\\micro\\second}]\$' offset 0,-1
	set xtics offset 0,-0.5
	set ylabel '\$y\\,[\\si{\\milli\\metre}]\$' offset 0,-1
	set zlabel '\$\\elfield\\,[\\si{\\kilo\\volt\\per\\metre}]\$' rotate by 90
	unset key
"""
for k in [8:-1:1; 10:13]
	x = X[k]
	t = x.t .- x.t[1]
	yy = ones(size(x.t)) * y[k]
	zz = zeros(size(x.t))
	@gsp :- t yy x.Iefish zz x.Iefish "w zerrorfill fc 'white' ls 1" :-
end
save(term="epslatex size 12cm,8cm", output="plots/period-elfield.tex")
