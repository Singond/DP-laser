function [r, a] = correlate_powermeters(varargin)
	if (nargin < 1)
		error("correlate_powermeters: Need at least one argument");
	end
	if (isstruct(s = varargin{1}))
		if (!isscalar(s))
			r = zeros(numel(s), 2);
			a = zeros(numel(s), 1);
			for k = 1:numel(s)
				r(k,:) = correlate_powermeters(s(k));
				a(k) = s(k).amp;
			end
			return;
		end
		r = correlate_powermeters(s.pwrdata{1}, s.pwrdata{2});
		return;
	end

	if (nargin < 2)
		error("correlate_powermeters: Need two matrices");
	end
	[data1, data2] = varargin{:};
	[t, i1, i2] = intersect(data1(:,1), data2(:,1));
	r = polyfit(data1(i1,2), data2(i2,2), 1);
end
