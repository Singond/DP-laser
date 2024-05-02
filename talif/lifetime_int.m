pkg load optim;
pkg load singon-plasma;
addpath ../octave

if (!exist("lifetimebase", "var"))
	lifetime_base;
end
X = lifetimebase;

function x = process_lifetime(x)
	x.tau = x.fitl.tau;
end

X = arrayfun(@(x) crop_iccd(x, [143 167], [220 779]), X);
X = arrayfun(@correct_iccd, D);
X = arrayfun(@img_intensity, X);
X = arrayfun(@(x) fit_decay(x, "xmin", "peak"), X);
X = arrayfun(@process_lifetime, X);

lifetime = X;
