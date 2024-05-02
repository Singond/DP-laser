addpath ../octave

if (!exist("lifetimebase", "var"))
	lifetime_base;
end
X = lifetimebase;

X = arrayfun(@(x) crop_iccd(x, [143 167], [220 779]), X);
X = arrayfun(@correct_iccd, X);
X = arrayfun(@normalize_intensity, X);

lifetime = struct([]);
warnstate = warning("query", "singon-plasma:convergence");
warning("off", "singon-plasma:convergence");
for x = X
	x.inx = sum(x.in, 1);
	x.inx = convn(x.inx, ones(1, 5, 5), "same");
	x.fitsx = fit_decay(x.t, x.inx,
		"dim", 3, "xmin", 85, "xmax", 130, "progress");
	x.taux = arrayfun(@(a) a.fite.tau, x.fitsx);
	x.tausigx = arrayfun(@(a) a.fite.tausig, x.fitsx);

	lifetime(end+1) = x;
end
warning(warnstate, "singon-plasma:convergence");
