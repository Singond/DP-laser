pkg load report;

if (!exist("lifetime", "var"))
	lifetime_regions;
end

img = lifetime(2).img(:,:,12);
gp = gnuplotter;
gp.load("../style.gp");
gp.exec("set palette gray");
gp.exec("\n\
	set size ratio -1 \n\
	unset tics \n\
	unset key \n\
	unset colorbox \n\
	set terminal pngcairo \n\
	set output 'results/lifetime-regions.png' \n\
");
l = 1;
for poly = {poly_center, poly_edge1, poly_edge2}
	poly = poly{1};
	poly(:,2) = rows(img) - poly(:,2);
	p = rows(poly);
	for k = 1:rows(poly)
		gp.exec(sprintf(
			"set arrow nohead from first %g,%g to %g,%g front ls %d lw 3",
			poly(p,1), poly(p,2), poly(k,1), poly(k,2), l));
		p = k;
	end
	gp.exec(sprintf(
		"set label '%d' center at first %g,%g front tc ls %d font ',15'",
		l, mean(poly(1:2,1)), mean(poly(1:2,2)) - 36, l));
	l++;
end
gp.exec("plot '-' matrix with image");
gp.data(flipud(img));
clear gp;
