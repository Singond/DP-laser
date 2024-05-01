pkg load optim;
pkg load singon-plasma;
addpath ../octave

lifetime_base;

function x = process_lifetime(x)
	x.tau = x.fitl.tau;
end

D = arrayfun(@(x) crop_iccd(x, [143 167], [220 779]), D);
X = arrayfun(@correct_iccd, D);
X = arrayfun(@img_intensity, X);
X = arrayfun(@(x) fit_decay(x, "xmin", "peak"), X);
X = arrayfun(@process_lifetime, X);
