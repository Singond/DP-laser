function r = recalibrate_powermeter(varargin)
	k = 1;
	if (rows(varargin{k}) > 1)
		reference = varargin{k++};
		amp = varargin{k++};
		data = varargin{k++};
		pwrdata = data.pwrdata{1};
		p = interp1(amp, reference, data.amp, "extrap");
	else
		p = varargin{k++};
		pwrdata = varargin{k++};
	end
	invert = false;
	if (nargin >= k)
		invert = varargin{k++};
	end

	if (invert)
		p = [1 -p(2)] ./ p(1);
	end
	pwrdata(:,2) = polyval(p, pwrdata(:,2));
	r = pwrdata;
end

