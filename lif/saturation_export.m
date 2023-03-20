pkg load report;

saturation;

gp = gnuplotter;
gp.load("../style-cairo.gp");
gp.xlabel('energie pulzu $\\enlaser\\,[\\si{\\micro\\joule}]$');
gp.ylabel('intenzita $\\itylif\\,[\\si\\arbunit]$');
gp.exec("\n\
	set yrange [0:10] \n\
	unset key \n\
");
Escale = 1e6;
for k = 1:length(X)
	x = X(k);
	gp.plot(x.E * Escale, x.in, sprintf("w p ls %d", k));
end
Emin = 0;
Emax = max(X(1).E);

m = isfinite(X(2).E);
p = polyfit(X(2).E(m), X(2).in(m), logical([1 0]));
gp.plot([Emin Emax] * Escale, polyval(p, [Emin Emax]), "w l ls 2 dt 2");
gp.export("results/saturation-lg.tex", "cairolatex", "size 10cm,8cm");
clear gp Emin Emax m p;
