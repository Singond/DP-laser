addpath ../octave;

constants;
liflines_load;
rayleigh_air_main;
rayleigh;
saturation_base;
saturation_full_load;
lifetime_full_load;

conc = saturation(3);
conc.alpha = conc.fite.a;
conc.beta = conc.fite.b;
conc.tau = lifetime.taux;

pressure = 1e5;     # Ambient pressure [Pa]
temperature = 293;  # Ambient temperature [K]

conc.densair = pressure / (boltzmann * temperature);
printf("air number density:    %g m-3\n", conc.densair);

data = dlmread("../data/pimax_1024.dat");
conc.cameraeff.wl = data(:,1);
conc.cameraeff.eff = data(:,2);
conc.cameraeff.at_wavelen = @(wl)...
	interp1(conc.cameraeff.wl, conc.cameraeff.eff, wl, "extrap");

for k = 1:2
	data = dlmread(sprintf("data-common/sklo%d_filtrSe.dat", k), "", 16, 0);
	conc.camerafilter(k).wl = data(:,1);
	conc.camerafilter(k).T = data(:,2);
	conc.camerafilter(k).weight = data(:,3);
	conc.camerafilter(k).at_wavelen = @(wl)...
		interp1(conc.camerafilter(k).wl, conc.camerafilter(k).T, wl, "extrap");
end
clear data;

conc.liflines = liflines;
conc.liflines.eff = conc.cameraeff.at_wavelen(conc.liflines.wl);
T = 1;
for cfilter = conc.camerafilter
	T = T .* cfilter.at_wavelen(conc.liflines.wl);
end
conc.liflines.T = T;
clear T;

conc.rayleigh_wl = 196.032;
conc.rayleigh_eff = conc.cameraeff.at_wavelen(conc.rayleigh_wl);
conc.rayleigh_dxsect = rayleigh_air.dxsect(conc.rayleigh_wl);
printf("rayleigh x-section:    %g m2/sr\n", conc.rayleigh_dxsect);

conc.rayleigh_reference = R(1);
conc.Lr = conc.rayleigh_reference.Em;
conc.Mr = conc.rayleigh_reference.inm(60:100,50:150);

conc.kappa = 1;
warning("Using default kappa of 1\n");
printf("spectral overlap:      %f\n", conc.kappa);

## Calculate concentration (density)
conc.n = numberdensity(conc, "all");
## Filter out negative and NAN values
conc.nf = conc.n;
conc.nf(conc.nf < 0) = 0;
conc.nf(isnan(conc.nf)) = 0;
## Remove outliers
disp("Removing outliers...");
conc.nf = rmoutliers(conc.nf, 0.5, 3);

## Average concentration from all images
wt = reshape(conc.E, 1, 1, []);
conc.nmw = sum(conc.nf .* wt ./ sum(wt(:)), 3);
conc.nma = mean(conc.nf, 3);
conc.nm = conc.nmw;
conc.n_std = std(conc.nf, 0, 3);

