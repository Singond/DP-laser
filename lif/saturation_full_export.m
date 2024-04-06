pkg load report;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifsm"))
	if (isfile("results/saturation.bin"))
		load results/saturation.bin
		if (isolderthan("results/saturation.bin", "saturation_full.m"))
			warning("loading saturation data from file older than script");
		end
	else
		saturation_full;
	end
end

x = saturation(1);

disp("Exporting results/saturation-full-params.tex...");
iscale = 1e-3;
ascale = 1e-9;
bscale = 1e-6;
maxa = quantile(x.fite.a(:), 0.98);
maxb = quantile(x.fite.b(:), 0.98);
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set title offset 0,-0.5 \n\
	set lmargin at screen 0.12 \n\
	set rmargin at screen 0.88 \n\
	set yrange [:] reverse \n\
	unset xtics \n\
	set ytics 10 \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	unset cblabel \n\
	set terminal cairolatex pdf colortext size 12.5cm,17cm \n\
	set output 'results/saturation-full-params.tex' \n\
	set multiplot layout 3,1 \n\
	unset key \n\
");
## Plot [1,1]
gp.settitle("referenční snímek");
gp.exec("\n\
	set tmargin at screen 0.95 \n\
	set bmargin at screen 0.70 \n\
");
gp.exec("plot '-' nonuniform matrix with image");
gp.data([0 x.xpos; x.ypos x.img(:,:,24) * iscale]);
## Plot [2,1]
gp.settitle('parametr $\\lifslope\\,[10^9]$');
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxa * ascale));
gp.exec("\n\
	set tmargin at screen 0.65 \n\
	set bmargin at screen 0.40 \n\
	set cbtics 1 \n\
");
gp.exec("plot '-' nonuniform matrix with image");
gp.data([0 x.xpos; x.ypos x.fite.a * ascale]);
## Plot [3,1]
gp.settitle('saturační parametr $\\lifsat\\,[\\si{\\per\\micro\\joule}]$');
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxb * bscale));
gp.exec("\n\
	set tmargin at screen 0.35 \n\
	set bmargin at screen 0.10 \n\
	set xtics out nomirror 10 \n\
	set cbtics 10 \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
");
gp.exec("plot '-' nonuniform matrix with image");
gp.data([0 x.xpos; x.ypos x.fite.b * bscale]);
clear gp;

