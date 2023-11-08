## -*- texinfo -*-
## @deftypefn  {} {@var{s} =} crop_iccd (@var{s}, @var{rows}, @var{cols})
## @deftypefnx {} {@var{s} =} crop_iccd (@dots{}, @qcode{"keepOriginal"})
##
## Crop image data in @var{s} to the region given by @var{rows} and @var{cols}.
##
## The image data are the fields @code{img} and @code{dark} of the
## struct @var{s}. These are replaced with their cropped equivalents.
## If the @qcode{"keepOriginal"} option is given, move the original
## data into the fields @code{img_orig} and @code{dark_orig} of @var{s},
## otherwise do not keep it.
## @end deftypefn
function x = crop_iccd(x, rows, cols, varargin)
	p = inputParser();
	p.addSwitch("keepOriginal");
	p.parse(varargin{:});
	args = p.Results;

	if (args.keepOriginal)
		x.img_orig = x.img;
		x.dark_orig = x.dark;
	end
	x.img  = x.img (rows(1):rows(2), cols(1):cols(2), :);
	x.dark = x.dark(rows(1):rows(2), cols(1):cols(2), :);
end

%!shared s
%! s.img = [0   0.4 0.6 0.2
%!          0.3 0.9 0.8 0.5
%!          0.2 0.7 0.8 0
%!          0   0.2 0.1 0.1];
%! s.dark = zeros(4);

%!test
%! c = crop_iccd(s, [2 3], [2 4]);
%! assert(c.img, [0.9 0.8 0.5
%!                0.7 0.8 0]);
%! assert(!isfield(c, "img_orig"));

%!test
%! c = crop_iccd(s, [2 3], [2 4], "keepOriginal");
%! assert(c.img, [0.9 0.8 0.5
%!                0.7 0.8 0]);
%! assert(c.img_orig, s.img);
