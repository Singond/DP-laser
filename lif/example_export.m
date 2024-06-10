pkg load report;
pkg load singon-plasma;

if (!exist("lifetime", "var"))
	lifetime_base;
end
if (!exist("R", "var") || !strcmp(R(1).name, "rayleigh1"))
	rayleigh;
end

flame = load_iccd("data-2023-01-20/obr1.SPE", "nodark", "nopower");
img_flame = mean(flame.img, 3);
img_flame -= min(img_flame(:));
img_flame /= max(img_flame(:));
gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set yrange [:] reverse \n\
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
gp.load("../gnuplot/style.gp");
gp.load("gnuplot/style-lif.gp");
gp.load("gnuplot/rule-lif.gp");
gp.exec("\n\
	set yrange [:] reverse \n\
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

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set yrange [:] reverse \n\
	set cbrange [0:8000] \n\
	unset xtics \n\
	unset ytics \n\
	set cbtics 2000 \n\
	unset key \n\
	set colorbox horizontal bottom \n\
");
gp.plotmatrix(flame.img(:,:,1), "with image");
gp.export("results/compare-flame-small.tex",
	"cairolatex", "pdf colourtext size 5.4cm,4cm");
gp.clearplot;

gp.exec("\n\
	set cbrange [0:2000] \n\
	set cbtics 500 \n\
");
gp.plotmatrix(R(1).img(:,:,1), "with image");
gp.export("results/compare-rayleigh-small.tex",
	"cairolatex", "pdf colourtext size 5.4cm,4cm");
