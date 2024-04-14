pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
addpath octave;

vertical_base;
regions;

X = vertical;
X = arrayfun(@(x) img_intensity(x, {region.mask}), X);

verticalr = struct([]);
for x = X
	x.h = x.control(:,1);
	n = 1:length(x.in);
	edges = x.control(:,2:3) + [0 1];  # Include right bound
	[~, idx] = histc(n, edges'(:));
	x.inh = zeros(rows(edges), columns(x.in));
	for k = 1:columns(x.in)
		x.inh(:,k) = accumarray(idx', x.in(:,k), [], @mean)(1:2:end);
	end
	verticalr(end+1) = x;
endfor

