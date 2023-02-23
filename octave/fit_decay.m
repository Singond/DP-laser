## -*- texinfo -*-
## @deftypefn {} {@var{x} =} fit_decay (@var{x})
##
## Fit exponential decay to @code{x.in(x.t)}.
## @end deftypefn
function x = fit_decay(x)
	[~, pk] = max(x.in);
	t = x.t(pk:end);
	t0 = t(1);
	in = x.in(pk:end);

	x.fitl.beta = polyfit(t, log(in), 1);
	x.fitl.tau = -1 / x.fitl.beta(1);
	x.fitl.f = @(t) exp(polyval(x.fitl.beta, t));

	model = @(t, b) b(1) .* exp(-t./b(2));
	b0 = [in(1), x.fitl.tau];
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t - t0, in, b0, model, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model(t - t0, s.beta);
	s.tau = s.beta(2);
	x.fite = s;

	model = @(t, b) b(1) .* exp(-t./b(2)) + b(3);
	b0 = [in(1), x.fite.tau, 0];
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t - t0, in, b0, model, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model(t - t0, s.beta);
	s.tau = s.beta(2);
	s.bg = s.beta(3);
	x.fitb = s;
end
