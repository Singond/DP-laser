## -*- texinfo -*-
## @deftypefn  {} {@var{mask} =} maskpolygon (@var{size}, @var{poly})
## @deftypefnx {} {@var{mask} =} maskpolygon (@var{width}, @var{height}, @
##     @var{poly})
## @deftypefnx {} {@var{mask} =} maskpolygon (@var{size}, @var{polyx}, @
##     @var{polyy})
## @deftypefnx {} {@var{mask} =} maskpolygon (@var{width}, @var{height}, @
##     @var{polyx}, @var{polyy})
## @end deftypefn
function m = maskpolygon(varargin)
	k = 1;
	if (isnumeric(varargin{k}) && isscalar(varargin{k}))
		height = varargin{k++};
		if (k > nargin || !isnumeric(varargin{k}) || !isscalar(varargin{k}))
			print_usage();
		endif
		width = varargin{k++};
	elseif (isnumeric(varargin{k}) && numel(varargin{k}) == 2)
		sizes = varargin{k++};
		height = sizes(1);
		width = sizes(2);
	else
		print_usage();
	endif

	if (isnumeric(varargin{k}) && isvector(varargin{k}))
		polyx = varargin{k++};
		if (k > nargin || !isnumeric(varargin{k}) || !isvector(varargin{k}))
			print_usage();
		endif
		polyy = varargin{k++};
	elseif (isnumeric(varargin{k}) && ndims(varargin{k}) == 2
			&& size(varargin{k}, 2) == 2)
		polys = varargin{k++};
		polyx = polys(:,1);
		polyy = polys(:,2);
	else
		print_usage();
	endif

	[xx, yy] = meshgrid(1:width, 1:height);
	m = inpolygon(xx, yy, polyx, polyy);
endfunction

%!shared checkmask

%!test
%! m = maskpolygon(100, 150, [10 20 80 30], [45 30 50 80]);
%! assert(size(m), [100 150]);
%! checkmask = m;

%!test
%! m = maskpolygon([100 150], [10 20 80 30], [45 30 50 80]);
%! assert(m, checkmask);

%!test
%! m = maskpolygon(100, 150, [10 45; 20 30; 80 50; 30 80]);
%! assert(m, checkmask);

%!test
%! m = maskpolygon([100 150], [10 45; 20 30; 80 50; 30 80]);
%! assert(m, checkmask);
