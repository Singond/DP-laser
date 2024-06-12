pkg load report;

wavelen_main;

## Energy variation

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");
gp.xlabel('$\\tim\\,[\\si{\\second}]$');
gp.ylabel('$\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.exec("\n\
	set tmargin at screen 0.95 \n\
	set rmargin at screen 0.95 \n\
	set xrange [0:400] \n\
	set yrange [4:14] \n\
	set xtics 100 offset 0,0.3 \n\
	set xlabel offset 0,0.8 \n\
	unset key \n\
");
edata = W(1).pwrdata{1};
gp.plot(edata(:,1), edata(:,2)*1e6, "w l ls 1");
gp.export("results/example-pwrdata-small.tex",
	"cairolatex", "pdf size 5.4cm,4cm");

Em = mean(edata(:,2));
Estd = std(edata(:,2));
printf("mean pulse energy:      %f uJ\n", Em * 1e6);
printf("pulse energy st. dev:   %f uJ (%f %%)\n",...
	Estd * 1e6, 100 * Estd / Em);
disp("");

## Dark frame variation
printf("Single series\n");
W1 = load_iccd("data-2023-01-20/scan9.SPE");
W1.imgs = squeeze(mean(mean(W1.img, 1), 2));
[W1.imgsmax, imax] = max(W1.imgs);
W1.darks = squeeze(mean(mean(W1.dark, 1), 2));
W1.darksmean = mean(W1.darks);
W1.darksstd = std(W1.darks);
printf("max img value:          %f\n", W1.imgsmax);
printf("mean dark value:        %f (%f %%)\n",...
	W1.darksmean, 100 * W1.darksmean / W1.imgsmax);
printf("dark std. deviation:    %f (%f %%)\n",...
	W1.darksstd, 100 * W1.darksstd / W1.darksmean);
disp("");

printf("Single frame (#%d)\n", imax);
w = W1.img(:,:,imax);
wd = mean(W1.dark, 3);
printf("max img value:          %f\n", max(w(:)));
printf("q95 img value:          %f\n", quantile(w(:), 0.95));
printf("mean img value:         %f\n", mean(w(:)));
printf("mean dark value:        %f\n", mean(wd(:)));
disp("");

printf("Multiple series (each averaged)\n");
rawimgs = cat(4, W.img) + cat(4, W.dark);
rawimgs = squeeze(mean(rawimgs, 3));
imgs = squeeze(mean(mean(rawimgs, 1), 2));
imgsmax = max(imgs);
darks = squeeze(mean(mean(cat(3, W.dark), 1), 2));
darksmean = mean(darks);
darksstd = std(darks);
printf("max img value:          %f\n", imgsmax);
printf("mean dark value:        %f (%f %%)\n",...
	darksmean, 100 * darksmean / imgsmax);
printf("dark std. deviation:    %f (%f %%)\n",...
	darksstd, 100 * darksstd / darksmean);
disp("");

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("gnuplot/style-lif.gp");
gp.exec("\n\
	set tmargin at screen 1 \n\
	set rmargin at screen 1 \n\
	set bmargin at screen 0 \n\
	set lmargin at screen 0 \n\
	set yrange [:] reverse \n\
	set cbrange [0:2500] \n\
	unset xtics \n\
	unset ytics \n\
	unset key \n\
	unset colorbox \n\
");
opts = "pdf size 3.15cm,2.7cm";
r = 50:110;
c = 60:130;
gp.plotmatrix(w(r,c), "with image");
gp.export("results/example-img-corr-small.tex", "cairolatex", opts);
gp.clearplot;
gp.plotmatrix(wd(r,c), "with image");
gp.export("results/example-img-dark-small.tex", "cairolatex", opts);
gp.clearplot;
gp.plotmatrix(w(r,c) + wd(r,c), "with image");
gp.export("results/example-img-raw-small.tex", "cairolatex", opts);
clear gp;
