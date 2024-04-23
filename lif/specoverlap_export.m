pkg load report;

if (!exist("vertical", "var") || !all(isfield(vertical, {"ins", "n"})))
	concentration_vertical;
end

disp("Exporting results/specoverlap.tex...");
p = specoverlap.profiles(1);
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.exec("\n\
	#set lmargin at screen 0.12 \n\
	#set rmargin at screen 0.83 \n\
	set xrange [1528.6:1530] \n\
	#set xtics 5 \n\
	#set ytics 5 \n\
	set xlabel 'frekvence $\\freq\\,[\\si{\\tera\\hertz}]$' \n\
	set ylabel 'normalizovaná intenzita $[\\si{\\per\\tera\\hertz}]$' \n\
	set key top left Left reverse samplen 2 \n\
");
##gp.exec(...
##	'set cblabel "hustota atomů $\\ndensse\\,[10^{%d}\\si{\\per\\metre\\cubed}]$" offset 1,0',...
##	-log10(nscale));
gp.plot(p.ff, p.l,  "w l t'laser (model)'");
gp.plot(p.ff, p.la, "w l t'laser + absorpce (data)'");
gp.export("results/specoverlap.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");

