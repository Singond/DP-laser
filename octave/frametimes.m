## -*- texinfo -*-
## @deftypefn  {} {@var{s} =} frametimes (@var{s}, @var{ftrig})
## @deftypefnx {} {@var{s} =} frametimes (@var{s}, @var{ftrig}, @var{delay})
##
## Estimate times of start and end of each frame exposure.
##
## @var{ftrig} is camera triggering frequency.
## If not given, it defaults to 1.
##
## If @var{delay} is given, assume that much seconds of offset
## between starting power measurement and camera capture.
## This value is added to the start and end time of each frame.
## @end deftypefn
function x = frametimes(x, ftrig = 1, delay = 0)
	x.imgt = frametimes_princeton_spe(x.imgm, 1/ftrig);
	x.imgt += delay;
end
