## -*- texinfo -*-
## @deftypefn {} {@var{S} =} correct_iccd (@var{S})
##
## Correct image data in struct @var{S}.
##
## Modify @code{@var{S}.img} by subtracting the dark image
## @code{@var{S}.dark} and clipping negative values to 0.
## @end deftypefn
function x = correct_iccd(x)
	## TODO: Eliminate outliers

	## Subtract dark frame
	x.dark = mean(x.dark, 3);
	x.img -= x.dark;
	## Clip negative values
	x.img(x.img < 0) = 0;
end
