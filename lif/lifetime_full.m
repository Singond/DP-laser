lifetime_base;

x = lifetime(2);
# Select area of interest and crop the data to it
x = crop_iccd(x, [60 100], [50 150]);

# Normalize intensity
x.in = x.img ./ x.acc;

# Fit intensity decay to obtain lifetime tau
x.fits = fit_decay(x.t, x.in,
	"dim", 3, "xmin", 8, "xmax", 15, "progress");
x.tau = arrayfun(@(a) a.fite.tau, x.fits);
x.tausig = arrayfun(@(a) a.fite.tausig, x.fits);  # uncertainty of tau

# Select valid data points
x.tauvalid = arrayfun(@(a) a.fite.cvg, x.fits);
x.tau(!x.tauvalid) = NaN;

x.inx = sum(x.in, 1);
x.fitsx = fit_decay(x.t, x.inx,
	"dim", 3, "xmin", 8, "xmax", 15, "progress");
x.taux = arrayfun(@(a) a.fite.tau, x.fitsx);
x.tausigx = arrayfun(@(a) a.fite.tausig, x.fitsx);

lifetime = x;
