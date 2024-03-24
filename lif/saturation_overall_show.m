saturation_overall;

Escale = 1e6;

figure();
hold on;
for x = saturation_separate;
	plot(x.E * Escale, x.in, "-d");
end
hold off;
title("Integral LIF intensity (data only)");
xlabel("energy E [\\mu{}J]");
ylabel("LIF intensity F [a.u.]");

figure();
x = saturationt;
[Lmin, Lmax] = bounds(x.E);
LL = linspace(0, Lmax);
c = get(gca, "colororder")(get(gca, "colororderindex"),:);
plot(x.E * Escale, x.lif(:), "d",
		"color", c, "displayname", "data",
	LL * Escale, x.fitl.f(LL),
		"b:", "color", c, "displayname", "polynomial fit",
	LL * Escale, x.fite.f(LL),
		"b--", "color", c, "displayname", "general fit");
title(sprintf(...
	"Integral LIF intensity\nfitted saturation parameter \\beta = %g \\mu{}J^{-1}",...
	x.fite.b * 1e-6));
xlabel("energy E [\\mu{}J]");
ylabel("LIF intensity F [a.u.]");
legend location northwest;
