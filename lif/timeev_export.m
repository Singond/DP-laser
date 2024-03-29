pkg load report;

if (!exist("lifetime", "var"))
	lifetime_base;
end

img = lifetime(2).img;
imin = 0;
imax = 2000;
t = lifetime(2).t;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec(sprintf("set cbrange [%g:%g]", imin, imax));
gp.exec("\n\
	set yrange [:] reverse \n\
	set terminal cairolatex pdf colortext size 12.5cm,17cm \n\
	set output 'results/timeev.tex' \n\
	set multiplot layout 3,2 \n\
	unset key \n\
	unset colorbox \n\
");
row = 1;
col = 1;
colpos = [0.14 0.56; 0.58 1.0];
rowpos = linspace(1, 0.12, 5)' - [0 0.22];
for k = [11:13 15:2:19 21 25]
	gp.exec("set tmargin at screen %f", rowpos(row, 1));
	gp.exec("set bmargin at screen %f", rowpos(row, 2));
	gp.exec("set lmargin at screen %f", colpos(col, 1));
	gp.exec("set rmargin at screen %f", colpos(col, 2));
	if (row == 4)
		gp.exec("set xtics out nomirror 40");
		gp.exec("set xlabel '$x$ [\\si\\pixel]'");
	else
		gp.exec("unset xtics");
		gp.exec("unset xlabel");
	end
	if (col == 1)
		gp.exec("set ytics out 40");
		gp.exec("set ylabel '$y$ [\\si\\pixel]'");
	else
		gp.exec("unset ytics");
		gp.exec("unset ylabel");
	end
	gp.exec(sprintf(
		"set label 2 't = %.1f ns' left at first 20,10 front tc 'white' font ',15'",
		t(k)));
	gp.exec("plot '-' matrix with image");
	gp.data(img(:,:,k));
	if (row < 4)
		row += 1;
	else
		row = 1;
		col += 1;
	end
end
clear gp;

