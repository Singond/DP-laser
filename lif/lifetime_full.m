lifetime_base;

x = lifetime(2);
x.aoi.rows = [60 90];
x.aoi.cols = [50 150];
x = crop_iccd(x, x.aoi.rows, x.aoi.cols);
x.in = x.img ./ x.acc;
fits = fit_decay(x.t, x.in,
	"dim", 3, "xmin", 7e-9, "xmax", 15e-9, "progress");
tau = arrayfun(@(a) a.fite.tau, fits);
