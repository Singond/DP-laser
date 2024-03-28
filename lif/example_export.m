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
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set yrange reverse \n\
	set xlabel '$\\xpos\\,[\\si\\pixel]$' \n\
	set ylabel '$\\ypos\\,[\\si\\pixel]$' \n\
	unset key \n\
	unset colorbox \n\
	set terminal cairolatex pdf colortext size 12cm,8cm \n\
	set output 'results/flame.tex' \n\
	plot '-' matrix with image \n\
");
gp.data(img_flame);
gp.exec("\n\
	unset output \n\
	set margins 0, 0, 0, 0 \n\
	unset tics \n\
	unset xlabel \n\
	unset ylabel \n\
	set terminal pngcairo \n\
	set output 'results/flame.png' \n\
	plot '-' matrix with image \n\
");
gp.data(img_flame);
clear gp;

img_lif = lifetime(2).img(:,:,12);
gp = gnuplotter;
gp.load("../style.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set yrange reverse \n\
	set margins 0, 0, 0, 0 \n\
	unset tics \n\
	unset key \n\
	unset colorbox \n\
	set terminal pngcairo \n\
	set output 'results/lif-example.png' \n\
	plot '-' matrix with image \n\
");
gp.data(img_lif);
clear gp;
