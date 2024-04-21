pkg load singon-plasma;
addpath ../octave;

location_load;
rayleigh;
vertical_base;

X = vertical;
X = arrayfun(@normalize_intensity, X);
X = arrayfun(@(x) px2mm(x, location), X);

vertical = struct([]);
for x = X
	x.h = x.control(:,1);
	x.ymm = x.ymm + reshape(x.h, 1, []);
	n = 1:size(x.img, 3);
	edges = x.control(:,2:3) + [0 1];  # Include right bound
	[~, x.hidx] = histc(n, edges'(:));
	x.inh = accumdim(x.hidx, x.in, 3, [], @mean);
	x.inh = x.inh(:,:,1:2:end);        # Remove transition frames

	## Stack the images
	x.ys = min(x.ymm(:)):(1/location.pxpermm):max(x.ymm(:));
	x.ys = flipud(x.ys(:));
	x.ins = ymosaic(x.ys,...
		mat2cell(x.inh, rows(x.inh), columns(x.inh), ones(size(x.h))),
		mat2cell(x.ymm, rows(x.ymm), ones(size(x.h))),
		beamprofile(:,1));

	vertical(end+1) = x;
endfor
clear X;
