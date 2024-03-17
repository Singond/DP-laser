## -*- texinfo -*-
## @deftypefn  {} {@var{s} =} frame_pulse_energy (@var{s})
## @deftypefnx {} {@var{s} =} frame_pulse_energy (@var{s}, @var{frametimes_args})
##
## Calculate mean laser energy for each camera frame.
##
## The energy in @code{s.pwrdata} is averaged over the frame times
## taken from @code{s.imgt}.
## If the field @code{imgt} is not set, it is calculated automatically
## using the @code{frametimes} function.
## Additional arguments to @code{frametimes} can be given after @var{s}.
##
## The result is the input struct with the field @code{E} set
## to the calculated energy.
##
## @seealso{frametimes}
## @end deftypefn
function x = frame_pulse_energy(x, varargin)
	if (!isfield(x, "imgt"))
		x = frametimes(x, varargin{:});
	endif

	x.E = [];
	for k = 1:length(x.pwrdata)
		pwrdata = x.pwrdata{k};
		valid = !isinf(pwrdata(:,2));
		x.E(:,k) = align_energy(pwrdata(valid,1), pwrdata(valid,2), x.imgt);
	endfor
end
