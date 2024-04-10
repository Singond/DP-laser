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
f_alpha = figure("name", "Proportionality parameter");
ascale = 1e-9;
gp.title('Proportionality parameter \alpha');
gp.xlabel("horizontal position x [px]");
gp.ylabel(sprintf("proportionality parameter \\alpha [10^{%d}]", -log10(ascale)));
gp.plot(x.xpos, x.fitex.a * ascale, "w p ps 0.5");
gp.plot(x.xpos, x.fitex.b * ascale, "w p ps 0.5 axes x1y2");
gp.export("results/saturation-x-params.tex", "cairolatex", "pdf size 12cm,8cm");
clear gp;
