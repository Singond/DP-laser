## -*- texinfo -*-
## @deftypefn  {} {@var{r} =} fit_decay (@var{x}, @var{y})
## @deftypefnx {} {@var{r} =} fit_decay (@dots{}, @qcode{"from"}, @var{x0})
## @deftypefnx {} {@var{r} =} fit_decay (@dots{}, @qcode{"dim"}, @var{dim})
## @deftypefnx {} {@var{s} =} fit_decay (@var{struct})
##
## Fit exponential decay to @code{x(y)}.
##
## The fitted data are clipped by the optional argument @var{x0}.
## All data points with lower values of @var{x} will be ignored.
## The default is @qcode{"auto"}, which sets @var{x0} to the value
## corresponding to maximum @var{y}.
##
## If @var{y} is a matrix, fit along columns of @var{y}
## and put the results into a cell array with the remaining dimensions.
## The operating dimension can be changed by the @var{dim} parameter.
## @end deftypefn
function x = fit_decay(varargin)
	pkg load optim;

	## Overload for struct argument
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
	end

	p = inputParser;
	p.addRequired("x", @isnumeric);
	p.addRequired("y", @isnumeric);
	p.addParameter("from", "auto");
	p.addParameter("dim", 1, @isnumeric);
	p.parse(varargin{:});
	t = p.Results.x;
	in = p.Results.y;
	t0 = p.Results.from;
	dim = p.Results.dim;

	if (ischar(t0) && strcmp(t0, "auto"))
		[~, pk] = max(in);
		t0 = t(1);
	elseif (!isnumeric(t0))
		print_usage();
	end

	if (isvector(in))
		t = t(t >= t0);
		in = in(t >= t0);
		x = _fit_decay(t - t0, in);
	else
		sz = size(in);
		if (length(t) != size(in, dim))
			error("Incompatible dimensions");
		end

		## Move dimension DIM to the beginning
		dims = 1:ndims(in);
		otherdims = dims(dims != dim);
		in = permute(in, [dim otherdims]);
		## Squash higher dimensions
		in = reshape(in, length(t), []);

		m = t >= t0;
		t = t(m);
		x = cell(sz(otherdims));
		for k = 1:columns(in)
			ink = in(m, k);
			x{k} = _fit_decay(t - t0, ink);
		end
	end
end

function x = _fit_decay(t, in)
	## Non-zero elements
	nz = in > 0;

	## Linearized model (preliminary fit)
	x.fitl.beta = polyfit(t(nz), log(in(nz)), 1);
	x.fitl.tau = -1 / x.fitl.beta(1);
	x.fitl.f = @(t) exp(polyval(x.fitl.beta, t));

	## Exponential model
	b0 = [in(1), x.fitl.tau];
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t, in, b0, @model_simple, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model_simple(t, s.beta);
	s.tau = s.beta(2);
	x.fite = s;

	## Exponential model with constant
	b0 = [in(1), x.fite.tau, 0];
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t, in, b0, @model_yconst, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model_yconst(t, s.beta);
	s.tau = s.beta(2);
	s.bg = s.beta(3);
	x.fitb = s;

	## Correct exponential model using new y-intercept
	b0 = x.fitb.beta(1:2);
	s = struct();
	[~, s.beta, s.cvg, s.iter] = leasqr(t, in, b0, @model_simple, [], 30);
	if (!s.cvg)
		warning("Convergence not reached after %d iterations.", s.iter);
	end
	s.f = @(t) model_simple(t, s.beta);
	s.tau = s.beta(2);
	x.fite = s;
end

function r = model_simple(t, b)
	r = b(1) .* exp(-t./b(2));
end

function r = model_yconst(t, b)
	r = b(1) .* exp(-t./b(2)) + b(3);
end
