pkg load optim;

saturation_base;

X = saturation;

function F = model_exp(Ly, p)
	F = p(1) - (p(1)/p(2)) * log(1 + p(2) * Ly) ./ Ly;
end

function r = fit_saturation(x, y, p0)
	s = struct;
	s.bounds = [0 Inf; 0 Inf];
	warning off backtrace local
	try
		[~, p, cvg, iter] = leasqr(x, y, p0,
			@(Ly, p) model_exp(Ly, p),
			[], 30, [], [], [], s);
		if (!cvg)
			warning(
				"fit_saturation: Convergence not reached after %d iterations.",
				iter);
		end
		r = [p(:); iter];
	catch err
		warning("fit_saturation: Fit failed: %s", err.message);
		r = [p0; 0];
	end
end

saturation = struct;
k = 1;
for x = X
	## Crop to area of interest
	x = crop_iccd(x, [63 95], [50 150]);

	## Normalize LIF intensity
	x.lifx = sum(x.img, 1) ./ x.acc;

	## Laser intensity. Called E in older code, but L is less ambiguous.
	x.L = x.E;

	p = polyfitm(reshape(x.L, 1, 1, []), x.lifx, logical([1 1 0]), 3);
	x.fitlx.a = p(:,:,2);
	x.fitlx.b = -p(:,:,1) * (3 / 2) ./ x.fitlx.a;
	x.fitlx.f = @(yi,xi,Ly) polyval(p(yi,xi,:)(:), Ly);

	b0 = cat(3, 2 * max(x.fitlx.a ./ x.fitlx.b, 0), max(x.fitlx.b, 0));
	r = dimfun(@fit_saturation, 3, reshape(x.L, 1, 1, []), x.lifx, b0);
	x.fitex.a = r(:,:,1) .* r(:,:,2) ./ 2;
	x.fitex.b = r(:,:,2);
	x.fitex.iter = r(:,:,3);
	x.fitex.f = @(yi,xi,Ly) model_exp(Ly, r(yi,xi,1:2));

	saturation(k++) = x;
end
