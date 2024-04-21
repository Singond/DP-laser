pkg load report;

vertical_regions;

leg = {
	'$\SI{700}{\sccm}\ \text{\ce{Ar}} + \SI{300}{\sccm}\ \text{\ce{H_2}}$'
	'$\SI{700}{\sccm}\ \text{\ce{Ar}} + \SI{300}{\sccm}\ \text{\ce{H_2}}$'
	'$\SI{175}{\sccm}\ \text{\ce{Ar}} + \SI{150}{\sccm}\ \text{\ce{H_2}}$'
	'$\SI{175}{\sccm}\ \text{\ce{Ar}} +  \SI{50}{\sccm}\ \text{\ce{H_2}}$'
};

gp = gnuplotter;
gp.load("../gnuplot/style.gp");
gp.load("../gnuplot/style-cairo.gp");

p = cell;
p{1} = gp.newplot();
p{2} = gp.newplot();
p{3} = gp.newplot();
p{1}.title("střed");
p{2}.title("okraj");
p{3}.title("okraj");
for pl = p
	pl = pl{1};
	pl.xlabel('výška $\\flamey\\,[\\si{\\milli\\metre}]$');
	pl.ylabel('intenzita $\\itylif\\,[\\si\\arbunit]$');
end
gp.exec("\n\
	set key below right samplen 2 height 2 \n\
");

for k = 1:length(verticalr)
	x = verticalr(k);
	for l = 1:columns(x.in)
		p{l}.plot(x.h, x.inh(:,l), sprintf(
			"w p t '%s'", leg{k}));
	end
endfor

gp.export(p{1}, "results/vertical-center.tex", "cairolatex", "size 8cm,10cm");
gp.export(p{2}, "results/vertical-edgel.tex", "cairolatex", "size 8cm,10cm");
gp.export(p{3}, "results/vertical-edger.tex", "cairolatex", "size 8cm,10cm");
clear gp k;
