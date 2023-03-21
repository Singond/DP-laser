pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

X = struct;
x = load_iccd("data-2023-01-20/decay1.SPE");
x.dt = 1e-9;
X(1) = x;

x = load_iccd("data-2023-01-20/decay2.SPE");
x.dt = 5e-10;
X(2) = x;

X = arrayfun(@correct_iccd, X);

s = size(X(1).img(:,:,1));
poly_center = [95 72; 102 72; 102 88; 95 88];
poly_edge1  = [73 72; 80 72; 80 88; 73 88];
poly_edge2  = [117 72; 124 72; 124 88; 117 88];
mask_center = maskpolygon(s, poly_center);
mask_edge1  = maskpolygon(s, poly_edge1);
mask_edge2  = maskpolygon(s, poly_edge2);

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
