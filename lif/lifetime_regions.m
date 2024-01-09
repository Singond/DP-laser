lifetime_base;

poly_center = region(1).shape;
poly_edge1  = region(2).shape;
poly_edge2  = region(3).shape;

mask_center = region(1).mask;
mask_edge1  = region(2).mask;
mask_edge2  = region(3).mask;

lifetime_old = lifetime;
lifetime = struct([]);
for x = lifetime_old;
	x.in_center = img_intensity(x.img, mask_center) ./ x.acc;
	x.fit_center = fit_decay(x.t, x.in_center, "xmin", "peak", "ymin", 0.1);
	x.tau_center = x.fit_center.fite.tau;
	x.in_edge1 = img_intensity(x.img, mask_edge1) ./ x.acc;
	x.fit_edge1 = fit_decay(x.t, x.in_edge1, "xmin", "peak", "ymin", 0.1);
	x.tau_edge1 = x.fit_edge1.fite.tau;
	x.in_edge2 = img_intensity(x.img, mask_edge2) ./ x.acc;
	x.fit_edge2 = fit_decay(x.t, x.in_edge2, "xmin", "peak", "ymin", 0.1);
	x.tau_edge2 = x.fit_edge2.fite.tau;
	lifetime(end+1) = x;
endfor
clear lifetime_old;
