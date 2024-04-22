addpath ../octave;

constants;
if (!exist("W", "var") || !isfield(W, "fit"))
	wavelen_main;
end

## Laser line
laser.wl = 196.03;
laser.freq = 1e-3 * lightspeed / laser.wl;

## Laser line width
laser.Dwn = 5;                                            # FWHM [cm-1]
laser.Dfreq = lightspeed * laser.Dwn * 1e-10;             # FWHM [THz]
laser.sigmafreq = laser.Dfreq ./ (2 * sqrt(2 * log(2)));  # gaussian sigma [THz]

## Modeled laser line
ff = linspace(1528, 1531, 1001)';
l = normpdf(ff, laser.freq, laser.sigmafreq);

profiles = struct([]);
for x = W
	x.wn = 1e7 ./ x.wl;                  # [cm-1]
	x.freq = 1e-3 * lightspeed ./ x.wl;  # [THz]

	## Convert line widths to frequency
	x.sigmafreq = 1e-3 * x.fit.sigma * lightspeed / laser.wl^2;  # [THz]
	x.gammafreq = 1e-3 * x.fit.gamma * lightspeed / laser.wl^2;  # [THz]

	## Model measured line (laser + absorption)
	x.ff = ff;
	x.l = l;
	p = x.fit.p;
	x.freqpk = 1e-3 * lightspeed / p(3);
	x.la = voigt(x.ff, x.sigmafreq, x.gammafreq, x.freqpk);

	## The same model from the wavelength representation.
	## This is just a check, it should be equal to x.la.
	x.lawl = voigt(x.wl, p(1), p(2), p(3));
	## lawl is normed in wavelength, but we want frequency
	x.lawl = x.lawl ./ abs(trapz(x.freq, x.lawl));

	## Spectral overlap
	x.kappa = voigt(0, 1e12 * x.sigmafreq, 1e12 * x.gammafreq);

	profiles(end+1) = x;
end
clear W_old;

specoverlap.laser = laser;
specoverlap.profiles = profiles;
