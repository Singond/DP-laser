## -*- texinfo -*-
## @deftypefn  {} {@var{x} =} img_intensity (@var{x})
## @deftypefnx {} {@var{x} =} img_intensity (@var{x}, @var{mask})
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
