## -*- texinfo -*-
## @deftypefn  {} {@var{x} =} img_intensity (@var{x})
## @deftypefnx {} {@var{x} =} img_intensity (@var{x}, @var{mask})
## @deftypefnx {} {@var{struct} =} img_intensity (@var{struct}, @dots{})
## @end deftypefn
function r = img_intensity(x, mask = [])
	if (isstruct(x))
		img = x.img;
		acc = x.acc;
	elseif (isnumeric(x))
		img = x;
	else
		error("img_intensity: X must be a numeric array or a struct");
	end

	if (!isempty(mask))
		img = img .* mask;
		masksum = sum(mask(:));
	else
		masksum = prod(size(img, 1, 2));
	end

	in = squeeze(sum(sum(img, 1), 2));
	in = in ./ masksum;

	if (isstruct(x))
		r = x;
		r.inraw = in;
		r.in = in ./ acc;
	else
		r = in;
	end
end

%!shared img, mask1, mask2
%! img = [
%!   6 7 5 9 1
%!   2 4 3 8 2
%!   0 9 2 8 4
%!   1 3 6 7 1
%!   6 2 0 7 9
%! ];

%!assert(img_intensity(img), mean(img(:)));

%!test
%! x.img = img;
%! x.acc = 2;
%! x = img_intensity(x);
%! assert(x.inraw, mean(img(:)));
%! assert(x.in, mean(img(:)) / 2);

%! mask1 = [
%!   0 0 0 0 0
%!   0 1 1 1 0
%!   0 1 1 1 0
%!   0 1 1 1 0
%!   0 0 0 0 0
%! ];
%! mask2 = [
%!   1 1 1 1 0
%!   1 0 0 0 1
%!   1 1 0 1 0
%!   0 0 0 1 1
%!   1 0 1 0 1
%! ];

%!assert(img_intensity(img, mask1), mean(img(2:4,2:4)(:)));

%!test
%! x.img = img;
%! x.acc = 2;
%! x = img_intensity(x, mask1);
%! assert(x.inraw, mean(img(2:4,2:4)(:)));
%! assert(x.in, mean(img(2:4,2:4)(:)) / 2);

%!assert(img_intensity(img, mask2), mean(img(logical(mask2))));

%!test
%! x.img = img;
%! x.acc = 2;
%! x = img_intensity(x, mask2);
%! assert(x.inraw, mean(img(logical(mask2))));
%! assert(x.in, mean(img(logical(mask2))) / 2);
