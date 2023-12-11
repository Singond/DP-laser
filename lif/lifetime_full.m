lifetime_base;

x = lifetime(2);
# Select area of interest and crop the data to it
x.aoi.rows = [60 90];
x.aoi.cols = [50 150];
x = crop_iccd(x, x.aoi.rows, x.aoi.cols);

# Normalize intensity
x.in = x.img ./ x.acc;

# Fit intensity decay to obtain lifetime tau
x.fits = fit_decay(x.t, x.in,
	"dim", 3, "xmin", 7, "xmax", 15, "progress");
x.tau = arrayfun(@(a) a.fite.tau, x.fits);

lifetime = x;
