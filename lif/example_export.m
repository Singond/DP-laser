pkg load report;
pkg load singon-plasma;

if (!exist("lifetime", "var"))
	lifetime_base;
end

flame = load_iccd("data-2023-01-20/obr1.SPE", "nodark", "nopower");
img_flame = mean(flame.img, 3);
img_flame -= min(img_flame(:));
img_flame /= max(img_flame(:));
gp = gnuplotter;
gp.load("../style.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set size ratio -1 \n\
	set margins 0, 0, 0, 0 \n\
	unset tics \n\
	unset key \n\
	unset colorbox \n\
	set terminal pngcairo \n\
	set output 'results/flame.png' \n\
	set arrow 1 nohead from first 130,100 to 180,100 front lw 3 lc 'white' \n\
	set label 1 '3 mm' center at first 155,110 front tc 'white' font ',15' \n\
	plot '-' matrix with image \n\
");
gp.data(flipud(img_flame));
gp.exec("\n\
	unset output \n\
	unset arrow 1 \n\
	unset label 1 \n\
	set size ratio -1 \n\
	unset margins \n\
	load 'gnuplot/rule-lif.gp' \n\
	set autoscale noextend \n\
	set yrange reverse \n\
	set xtics out nomirror \n\
	set ytics out nomirror \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	set terminal cairolatex pdf colortext size 12cm,8cm \n\
	set output 'results/flame.tex' \n\
	plot '-' matrix with image \n\
");
gp.data(img_flame);
clear gp;

img_lif = lifetime(2).img(:,:,12);
gp = gnuplotter;
gp.load("../style.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set size ratio -1 \n\
	set margins 0, 0, 0, 0 \n\
	unset tics \n\
	unset key \n\
	unset colorbox \n\
	set terminal pngcairo \n\
	set output 'results/lif-example.png' \n\
	set arrow nohead from first 130,100 to 180,100 front lw 3 lc 'white' \n\
	set label '3 mm' center at first 155,110 front tc 'white' font ',15' \n\
	plot '-' matrix with image \n\
");
gp.data(flipud(img_lif));
clear gp;
