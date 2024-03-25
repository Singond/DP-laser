pkg load report;

if (!exist("R", "var") || !exist("Rt", "var"))
	rayleigh;
end

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.exec("\n\
	set key top left \n\
	set autoscale noextend \n\
	set offsets graph 0.04, graph 0.04, graph 0.04, graph 0.04 \n\
");
for r = R
	gp.plot(r.ypos, r.iny, sprintf(...
		'w l t "$\\\\SI{%.2f}{\\\\micro\\\\joule}$"', r.Em*1e6));
end
gp.xlabel('svislá poloha $\\ypos\\,[\\si\\pixel]$');
gp.ylabel('intenzita LIF $\\lif\\,[\\si\\arbunit]$');
gp.export("results/rayleigh-profile.tex", "cairolatex", "size 12cm,8cm");
clear gp;

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
gp.exec("\n\
	set key top left \n\
	set autoscale noextend \n\
	set offsets graph 0.04, graph 0.04, graph 0.04, graph 0.04 \n\
	set terminal cairolatex size 12cm,8cm \n\
	set output 'results/rayleigh-time.tex' \n\
");
gp.xlabel('čas $\\tim\\,[\\si\\second]$');
gp.ylabel('svislá poloha $\\ypos\\,[\\si\\pixel]$');
gp.exec('set zlabel "intenzita LIF $\\lif\\,[\\si\\arbunit]$"');
gp.exec("splot '-' with lines");
for k = 1:rows(Rt.t')
	D = [Rt.t(k)(ones(size(Rt.ypos))) Rt.ypos Rt.iny(:,k)];
	gp.data(D, "\n\n");
end
gp.exec("e");
clear gp;
