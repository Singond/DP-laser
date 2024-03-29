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
	set xtics 40 \n\
	set ytics 40 \n\
	set xlabel '$x$ [\\si\\pixel]' \n\
	set ylabel '$y$ [\\si\\pixel]' \n\
	unset colorbox \n\
	set terminal cairolatex pdf colortext size 8cm,6cm \n\
");
for k = [10:14 15:2:19 21:4:29]
	name = sprintf("results/timeev-%.1f.tex", t(k));
	printf("Writing %s\n", name);
	gp.exec(["set output '" name "'"]);
	gp.exec(sprintf(
		"set label 2 't = %.1f ns' left at first 20,10 front tc 'white' font ',15'",
		t(k)));
	gp.exec("plot '-' matrix with image");
	gp.data(img(:,:,k));
	gp.exec("unset output");
end
clear gp;

