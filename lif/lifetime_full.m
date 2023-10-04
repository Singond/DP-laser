lifetime_base;

x = lifetime(2);
x.in = x.img ./ x.acc;
aoi = {60:90, 50:150};  # Area of interest
fits = struct();
fits(aoi{:}) = fit_decay(x.t, x.in(aoi{:},:),
	"dim", 3, "from", 7e-9, "progress");
tau = NA(size(x.in)(1:2));
tau(aoi{:}) = arrayfun(@(a) a.fite.tau, fits(aoi{:}));
