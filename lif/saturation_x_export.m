pkg load report;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifx"))
	saturation_x;
end

x = saturation(3);

disp("Exporting results/saturation-x-params.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
ascale = 1e-9;
bscale = 1e-6;
gp.xlabel('poloha $\\ypos\\,[\\si\\pixel]$');
gp.ylabel('fluorescenční zesílení $\\lifslope\\,[10^9]$');
gp.exec("\n\
	set ytics in nomirror \n\
	set y2tics in nomirror \n\
	set y2label 'saturační parametr $\\lifsat\\,[\\si{\\per\\micro\\joule}]$' \n\
	set key top left Left reverse samplen 2 width 1 \n\
");
gp.plot(x.xpos, x.fitex.a * ascale, "w p ps 0.4 t '$\\lifslope$'");
gp.plot(x.xpos, x.fitex.b * bscale, "w p ps 0.5 axes x1y2 t '$\\lifsat$'");
gp.export("results/saturation-x-params.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");
clear gp;
