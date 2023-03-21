pkg load report;

if (!exist("lifetime", "var"))
	lifetime_main;
end

img = lifetime(2).img;
##b = quantile(img(:), [0.005 0.995]);
##imin = b(1);
##imax = b(2);
imin = 0;
imax = 2000;
t = lifetime(2).t;

gp = gnuplotter;
gp.load("../style-cairo.gp");
gp.exec("set palette model RGB functions 3 * (gray - 2/3.0), (3/2.0) * (gray - 1/3.0), gray");
gp.exec(sprintf("set cbrange [%g:%g]", imin, imax));
gp.exec("\n\
	set size ratio -1 \n\
	set margins 0, 0, 0, 0 \n\
	unset tics \n\
	unset key \n\
	unset colorbox \n\
	set terminal pngcairo size 594,309 \n\
	set terminal pngcairo \n\
	set arrow nohead from first 130,80 to 180,80 front lw 3 lc 'white' \n\
	set label 1 '3 mm' center at first 155,90 front tc 'white' font ',15' \n\
");
for k = [10:14 15:2:19 21:4:29]
	name = sprintf("results/timeev-%.1f.png", t(k) * 1e9);
	printf("Writing %s\n", name);
	gp.exec(["set output '" name "'"]);
	gp.exec(sprintf(
		"set label 2 't = %.1f ns' left at first 20,90 front tc 'white' font ',15'",
		t(k) * 1e9));
	gp.exec("plot '-' matrix with image");
	gp.data(flipud(img(20:end,:,k)));
	gp.exec("unset output");
end
clear gp;

