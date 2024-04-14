pkg load singon-plasma;
addpath ../octave;

vertical_base;

X = vertical;
X = arrayfun(@normalize_intensity, X);

vertical = struct([]);
for x = X
	x.h = x.control(:,1);
	n = 1:size(x.img, 3);
	edges = x.control(:,2:3) + [0 1];  # Include right bound
	[~, x.hidx] = histc(n, edges'(:));
	x.inh = accumdim(x.hidx, x.in, 3, [], @mean);
	x.inh = x.inh(:,:,1:2:end);        # Remove transition frames
	vertical(end+1) = x;
endfor
clear X;
