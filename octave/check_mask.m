## -*- texinfo -*-
## @deftypefn  {} {} check_mask (@var{img}, @var{mask})
## Show @var{mask} overlayed on @var{img}.
## @end deftypefn
function check_mask(img, mask)
	if (size(img, 3) == 3)
		img = rgb2gray(img);
	endif

	range = [min(img(:)) max(img(:))];
	img -= range(1);
	img /= diff(range);

	maskcolor = [1 0 0];
	nomaskcolor = [1 1 1];
	color = interp1([0; 1], [maskcolor; nomaskcolor], double(mask));
	combined = (color + img) ./ 2;
	mask3 = repmat(mask, 1, 1, 3);
	combined(mask3) = repmat(img, 1, 1, 3)(mask3);
	imshow(combined);
endfunction
