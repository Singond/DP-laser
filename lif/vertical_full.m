pkg load singon-plasma;
addpath ../octave;

location_load;
rayleigh;
vertical_base;

X = vertical;
X = arrayfun(@normalize_intensity, X);
X = arrayfun(@(x) px2mm(x, location), X);

## In this dataset, the atomizer seems to be shifted slightly to the left.
## To correct this, find the desired center as the centroid of signal:
y = sum(sum(X(1).in(60:100,:,:), 3), 1);
[~, pk] = max(y);
p = polyfit(X(1).xmm(pk-20:pk+20), log(y(pk-20:pk+20)), 2);
newx0 = -p(2) / (2 * p(1));

vertical = struct([]);
for x = X
	x.h = x.control(:,1);
	x.xmm = x.xmm - newx0;
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
