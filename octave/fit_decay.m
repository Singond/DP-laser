## -*- texinfo -*-
## @deftypefn  {} {@var{r} =} fit_decay (@var{x}, @var{y})
## @deftypefnx {} {@var{r} =} fit_decay (@var{struct})
##
## Fit exponential decay to @code{x(y)}.
## @end deftypefn
function x = fit_decay(varargin)
	pkg load optim;

	if (isstruct(varargin{1}))
		x = varargin{1};
		if (nargin > 1)
			r = fit_decay(x.t, x.in, varargin{2:end});
		else
			r = fit_decay(x.t, x.in);
		end
		x.fitl = r.fitl;
		x.fite = r.fite;
		x.fitb = r.fitb;
		return;
	else
		[t, in] = varargin{1:2};
	end

	[~, pk] = max(in);
	t = t(pk:end);
	t0 = t(1);
	in = in(pk:end);

	## Linearized model (preliminary fit)
	x.fitl.beta = polyfit(t, log(in), 1);
	x.fitl.tau = -1 / x.fitl.beta(1);
	x.fitl.f = @(t) exp(polyval(x.fitl.beta, t));

	## Exponential model
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

	## Exponential model with constant
	modelb = @(t, b) b(1) .* exp(-t./b(2)) + b(3);
	b0 = [in(1), x.fite.tau, 0];
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t - t0, in, b0, modelb, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) modelb(t - t0, s.beta);
	s.tau = s.beta(2);
	s.bg = s.beta(3);
	x.fitb = s;

	## Correct exponential model using new y-intercept
	b0 = x.fitb.beta(1:2);
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t - t0, in, b0, model, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model(t - t0, s.beta);
	s.tau = s.beta(2);
	x.fite = s;
end