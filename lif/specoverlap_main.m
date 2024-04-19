addpath ../octave;

constants;
if (!exist("W", "var") || !isfield(W, "fit"))
	wavelen_main;
end

Dwn = 5;                                      # laser line FWHM [cm-1]
Dfreq = lightspeed * Dwn * 1e-10;             # laser line FWHM [THz]
sigmafreq = Dfreq ./ (2 * sqrt(2 * log(2)));  # laser line sigma (normal) [THz]

laserwl = 196.03;
laserfreq = 1e-3 * lightspeed / laserwl;
