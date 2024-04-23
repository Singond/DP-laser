pkg load report;

if (!exist("specoverlap", "var"))
	specoverlap_main;
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
gp.plot(p.ff, p.l,  "w l t'$\\profilelaser$ (model)'");
gp.plot(p.ff, p.la, "w l t'$\\profileabs\\conv\\profilelaser$ (data)'");
gp.export("results/specoverlap.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");

