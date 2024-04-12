pkg load report;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifx"))
	saturation_x;
end
if (!exist("saturationt", "var"))
	saturation_overall;
end

x = saturation(3);

disp("Exporting results/saturation-x-params.tex...");
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
ascale = 1e-9;
bscale = 1e-6;
gp.xlabel('poloha $\\ypos\\,[\\si\\pixel]$');
gp.ylabel('intenzitní parametr $\\lifslope\\,[10^9]$');
gp.exec("\n\
	set ytics in nomirror \n\
	set y2tics in nomirror \n\
	set y2label 'saturační parametr $\\lifsat\\,[\\si{\\per\\micro\\joule}]$' \n\
	set key top left Left reverse samplen 2 width 1 \n\
");
gp.plot(x.xpos, x.fitex.a * ascale, "w p ps 0.4 t '$\\lifslopex$'");
gp.plot(x.xpos, x.fitex.b * bscale, "w p ps 0.5 axes x1y2 t '$\\lifsatx$'");
bt = saturationt.fite.b * bscale;
gp.plot(sprintf("%g", bt),...
	"w l axes x1y2 ls 2 dt '_' notitle");
gp.exec(horzcat("set label '$\\lifsatt = \\SI{%.3f}{\\per\\micro\\joule}$' ",...
	"tc ls 2 at graph 0.23, second %g center offset 0,0.6"),...
	bt, bt);
gp.export("results/saturation-x-params.tex",...
	"cairolatex", "pdf colourtext size 12cm,8cm");
clear gp;
