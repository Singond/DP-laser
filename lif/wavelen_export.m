pkg load report;

wavelen_main;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.title("Excitační profil (bez~prostorového filtru)");
gp.xlabel('vlnová délka laseru $\\enlaser\\,[\\si{\\nano\\metre}]$');
gp.ylabel('intenzita $\\itylif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [195.95:196.20] \n\
	set key top right samplen 2 height 1 \n\
");
k = 1;
for x = 1:5
	x = X(k);
	Em = mean(x.E(:,end));
	gp.plot(x.wl, x.in, sprintf(
		"w l ls %d t '$\\SI{%.0f}{\\micro\\joule}$'", k, Em*1e6));
	k++;
end
gp.export("results/excitprof-nofilter-lg.tex", "cairolatex", "size 10cm,8cm");
clear gp k;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.title("Excitační profil (s~prostorovým filtrem)");
gp.xlabel('vlnová délka laseru $\\enlaser\\,[\\si{\\nano\\metre}]$');
gp.ylabel('intenzita $\\itylif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set xrange [195.95:196.20] \n\
	set key top right samplen 2 height 1 \n\
");
k = 1;
for x = X(6:10)
	Em = mean(x.E(:,end));
	gp.plot(x.wl, x.in, sprintf(
		"w l ls %d t '$\\SI{%.2f}{\\micro\\joule}$'", k, Em*1e6));
	k++;
end
gp.export("results/excitprof-filter-lg.tex", "cairolatex", "size 10cm,8cm");
clear gp k;
