pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
addpath octave;

C = struct([]);
x = load_iccd("data-2023-01-20/caliper2mm.SPE", "nodark", "nopower");
x.d = 2;
C(end+1) = x;
x = load_iccd("data-2023-01-20/caliper3mm.SPE", "nodark", "nopower");
x.img(:,:,end) = [];  # Outlier
x.d = 3;
C(end+1) = x;
x = load_iccd("data-2023-01-20/caliper4mm.SPE", "nodark", "nopower");
x.d = 4;
C(end+1) = x;

function [w, b] = width_quantile(varargin)
	if (nargin == 2)
		[y, quant] = varargin{:};
		x = (1:rows(y))';
	else
		[x, y, quant] = varargin{:};
	end

	c = cumsum(y);
	c = c ./ max(c);
	b = [];
	for k = 1:columns(y)
		b(:,k) = interp1(c(:,k), x, quant);
	end
	w = diff(b, 1);
end

function [w, b, fit] = width_polyfit(x, y, order)
	fit.f = {};
	fit.p = {};
	b = NA(2, columns(y));
	for k = 1:columns(y)
		[~, imax] = max(y(:,k));
		xmax = x(imax);
		p = polyfit(x, real(log(y(:,k))), order);
		d3p = polyder(polyder(polyder(p)));
		z = roots(d3p);
		z = z(imag(z) == 0);
		bl = max(z(z' < xmax));
		br = min(z(z' > xmax));
		if (!isempty(bl) && !isempty(br))
			b(:,k) = [bl br];
		end
		fit.f{k} = @(x) exp(polyval(p, x));
		fit.p{k} = p;
	end
	w = diff(b, 1);
end

function [w, b] = width_height(x, y, height)
	b = NA(2, columns(y));
	for k = 1:columns(y)
		above = find(y(:,k) > height);
		l = min(above);
		r = max(above);
		b(1,k) = interp1(y([l-1 l],k), x([l-1 l]), height);
		b(2,k) = interp1(y([r r+1],k), x([r r+1]), height);
	end
	w = diff(b, 1);
end

heights = [4e5 4e5 3.7e5];
caliper.X = struct([]);
k = 1;
for x = C
	x.N = size(x.img, 3);
	x.intot = squeeze(sum(x.img(60:100,:,:), 1));
	x.inbg = mean(x.intot([1:50 150:end],:), 1);
	x.in = x.intot - x.inbg;

	idx = (1:rows(x.in))';
	peak = 70:130;
	#[x.dpx, x.dbounds] = width_quantile(idx, x.in, [0.1 0.9]);
	#[x.dpx, x.dbounds, x.infit] = width_polyfit(idx(peak), x.in(peak,:), 8);
	#[x.dpx, x.dbounds] = width_height(idx, x.in, 4.5e5);
	#[x.dpx, x.dbounds] = width_height(idx, x.in, heights(k));
	[x.dpx, x.dbounds] = width_height(idx, x.in, 0.60*mean(max(x.in)));
	caliper.X(end+1) = x;
	k++;
endfor

caliper.d = vertcat(caliper.X.d);
caliper.dd = repelem(caliper.d, [caliper.X.N]');
caliper.dpx = [caliper.X.dpx]';

p = polyfit(caliper.dd, caliper.dpx, logical([1 0]));
caliper.dfit1 = p;
caliper.pxpermm1 = p(1);
printf("image scale (linear):  %f px/mm\n", caliper.pxpermm1);

p = polyfit(caliper.dd, caliper.dpx, 1);
caliper.dfit2 = p;
caliper.pxpermm2 = p(1);
printf("image scale (offset):  %f px/mm\n", caliper.pxpermm2);
printf("image scale offset:    %f px\n", caliper.dfit2(2));

pxpermm = caliper.pxpermm1;
