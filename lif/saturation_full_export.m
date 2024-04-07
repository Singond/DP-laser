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

## Fitted parameters only
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
gp.exec("\n\
	unset multiplot \n\
	unset output \n\
	reset \n\
");

## Parameters and fits as one image
disp("Exporting results/saturation-full-paramsfits.tex...");
x = saturation(1);
points = [67 100; 71 100; 79 100; 89 100; 96 100];
pointsi = points - [min(x.ypos) min(x.xpos)] + 1;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set title offset 0,-0.5 \n\
	set lmargin at screen 0.12 \n\
	set rmargin at screen 0.88 \n\
	set terminal cairolatex pdf colortext size 12.5cm,18cm \n\
	set output 'results/saturation-full-paramsfits.tex' \n\
	set multiplot layout 2,1 margins 0.12, 0.9, 0.48, 0.97 \n\
	set yrange [:] reverse \n\
	unset key \n\
");
## Arrows and labels
for k = 1:rows(points)
	pos = points(k,[2 1]);
	gp.exec("set arrow 1%d from first %d,%d to %d,%d front ls %d",...
		k, pos + [-30, 0], pos, k);
	gp.exec("set arrow %d from first %d,%d to %d,%d front lc 'white' lw 4",...
		k, pos + [-30, 0], pos);
	gp.exec("set label %d '{[%d,%d]}' right at first %g,%g front tc ls %d",
		k, pos, pos + [-40, 0], k);
end
## Alpha
gp.settitle('parametr $\\lifslope\\,[10^9]$');
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxa * ascale));
gp.exec("\n\
	unset xtics \n\
	set ytics out nomirror 10 \n\
	set cbtics 1 \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
");
gp.exec("plot '-' nonuniform matrix with image");
gp.data([0 x.xpos; x.ypos x.fite.a * ascale]);
## Beta
gp.settitle('saturační parametr $\\lifsat\\,[\\si{\\per\\micro\\joule}]$');
gp.exec(sprintf("set cbrange [%g:%g]", 0, maxb * bscale));
gp.exec("\n\
	set xtics out nomirror 10 \n\
	set cbtics 10 \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
");
gp.exec("plot '-' nonuniform matrix with image");
gp.data([0 x.xpos; x.ypos x.fite.b * bscale]);
## Fits
gp.exec("\n\
	reset \n\
	set style line 1 ps 0.35 \n\
	set style line 2 ps 0.5 \n\
	set style line 3 ps 0.5 \n\
	set style line 4 ps 0.5 \n\
	set style line 5 ps 0.45 \n\
	set margins screen 0.12, screen 0.98, screen 0.07, screen 0.38 \n\
	set xlabel '$\\enlasery\\,[\\si{\\micro\\joule\\per\\pixel}]$' \n\
	set ylabel '$\\lif\\,[\\si\\arbunit]$' \n\
	set key top left Left reverse width 1 height 1 samplen 1 spacing 1 \n\
");
Escale = 1e6;
for k = 1:rows(pointsi)
	yi = pointsi(k,1);
	xi = pointsi(k,2);
	L = squeeze(x.Ly(yi,:));
	[Lmin, Lmax] = bounds(L);
	Lmin = min(x.Ly(pointsi(:,1),:)(:));
	LL = linspace(Lmin, Lmax);
	gp.plot(L * Escale, squeeze(x.lif(yi,xi,:)),...
		sprintf("w p ls %d t'$\\lbrack%d,%d\\rbrack$'",...
			k, points(k,2), points(k,1)));
	gp.plot(LL * Escale, x.fite.f(yi, xi, LL),...
		sprintf("w l ls %d dt 1 notitle", k));
end
gp.doplot();

clear gp;

