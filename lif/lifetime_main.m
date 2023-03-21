pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

regions;

X = struct;
x = load_iccd("data-2023-01-20/decay1.SPE");
x.dt = 1e-9;
X(1) = x;

x = load_iccd("data-2023-01-20/decay2.SPE");
x.dt = 5e-10;
X(2) = x;

X = arrayfun(@correct_iccd, X);

poly_center = region(1).shape;
poly_edge1  = region(2).shape;
poly_edge2  = region(3).shape;

mask_center = region(1).mask;
mask_edge1  = region(2).mask;
mask_edge2  = region(3).mask;

lifetime = struct([]);
for x = X
	x.t = (0:x.imgm.numframes - 1)' * x.dt;
	x.in_center = img_intensity(x.img, mask_center) ./ x.acc;
	x.fit_center = fit_decay(x.t, x.in_center);
	x.tau_center = x.fit_center.fite.tau;
	x.in_edge1 = img_intensity(x.img, mask_edge1) ./ x.acc;
	x.fit_edge1 = fit_decay(x.t, x.in_edge1);
	x.tau_edge1 = x.fit_edge1.fite.tau;
	x.in_edge2 = img_intensity(x.img, mask_edge2) ./ x.acc;
	x.fit_edge2 = fit_decay(x.t, x.in_edge2);
	x.tau_edge2 = x.fit_edge2.fite.tau;
	lifetime(end+1) = x;
endfor
clear X
