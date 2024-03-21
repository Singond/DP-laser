saturation_base;

saturation_separate = arrayfun(@img_intensity, saturation_separate);

x = img_intensity(saturation);
x.lif = x.in;

p = polyfit(x.E, x.lif, logical([1 1 0]));
x.fitl.a = p(2);
x.fitl.b = -p(1) * (3 / 2) ./ x.fitl.a;
x.fitl.f = @(L) polyval(p(:), L);

function F = model_exp(Ly, p)
	F = p(1) - (p(1)/p(2)) * log(1 + p(2) * Ly) ./ Ly;
end

s = struct;
s.bounds = [0 Inf; 0 Inf];
p0 = [2 * max(x.fitl.a ./ x.fitl.b, 0) max(x.fitl.b, 0)];
try
	[~, p, cvg, iter] = leasqr(x.E, x.lif, p0,
		@(L, p) model_exp(L, p),
		[], 30, [], [], [], s);
	if (!cvg)
		warning(
			"saturation_overall: Convergence not reached after %d iterations.",
			iter);
	end
catch err
	warning("dp-laser:fit-failed", ...
		"fit_saturation: Fit failed: %s", err.message);
	p = p0;
end

x.fite.a = p(1) .* p(2) ./ 2;
x.fite.b = p(2);
x.fite.iter = iter;
x.fite.f = @(L) model_exp(L, p);

saturationt = x;
