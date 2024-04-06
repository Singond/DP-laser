pkg load optim;
addpath octave;

rayleigh;
if (!exist("saturation", "var"))
	saturation_base;
end

X = saturation;

function r = fit_saturation(x, y, p0)
	global log;
	global calls;
	global total_calls;
	calls += 1;
	s = struct;
	s.bounds = [0 Inf; 0 Inf];
	warning off backtrace local;
	try
		[~, p, cvg, iter] = leasqr(x, y, p0,
			@(Ly, p) lif_planar_model_exp(Ly, p),
			[], 30, [], [], [], s);
		if (!cvg)
			warning(
				"fit_saturation: Convergence not reached after %d iterations.",
				iter);
		end
		r = [p(:); iter];
	catch err
		warning("dp-laser:fit-failed", ...
			"fit_saturation: Fit failed: %s", err.message);
		r = [p0; 0];
	end
	if (log && (mod(calls, 50) == 0) || calls == total_calls)
		printf("fit_saturation: %d/%d\n", calls, total_calls);
	end
end

## TODO: Using amp 50 for beam profile. Interpolate for other powers?
beamprofile = R(1).iny ./ sum(R(1).iny);
beamprofile_ypos = R(1).ypos;

## Smoothing kernel
kernel = ones(5, 5);
kernel = kernel ./ sum(kernel(:));

global log = true;
global calls;
global total_calls;

saturation = struct;
k = 1;
for x = X
	printf("Processing '%s'...\n", x.name);
	tstart = time;

	## Crop to area of interest
	x = crop_iccd(x, [60 100], [50 150]);

	## Normalize LIF intensity
	x.lif = x.img ./ x.acc;

	## Smooth LIF intensity
	x.lifsm = convn(x.lif, kernel, "same");

	## Laser intensity. Called E in older code, but L is less ambiguous.
	pr = interp1(beamprofile_ypos, beamprofile, x.ypos);
	x.Ly = reshape(x.E, 1, 1, []) .* pr;    # Laser energy at y
	Ly = repmat(x.Ly, [1 size(x.lifsm, 2) 1]);

	## Fit with approximate polynomial
	p = polyfitm(Ly, x.lifsm, logical([1 1 0]), 3);
	x.fitl.a = p(:,:,2);
	x.fitl.b = -p(:,:,1) * (3 / 2) ./ x.fitl.a;
	x.fitl.f = @(yi,xi,Ly) polyval(p(yi,xi,:)(:), Ly);

	## Fit with true model, using the previous fit as a starting point
	b0 = cat(3, 2 * max(x.fitl.a ./ x.fitl.b, 0), max(x.fitl.b, 0));
	calls = 0;
	total_calls = numel(x.lifsm(:,:,1));
	warning off dp-laser:fit-failed;
	r = dimfun(@fit_saturation, 3, x.Ly, x.lifsm, b0);
	x.fite.a = r(:,:,1) .* r(:,:,2) ./ 2;
	x.fite.b = r(:,:,2);
	x.fite.iter = r(:,:,3);
	x.fite.f = @(yi,xi,Ly) lif_planar_model_exp(Ly, r(yi,xi,1:2));

	failed = (x.fite.iter == 0);
	if (any(failed))
		warning("General fit failed for %d/%d data points\n",...
			sum(failed(:)), numel(x.fite.iter));
	end

	printf("Finished in %.0f s\n\n", time - tstart);
	saturation(k++) = x;
end
