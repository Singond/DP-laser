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

caliper.X = struct([]);
for x = C
	x.N = size(x.img, 3);
	x.intot = squeeze(sum(x.img(60:100,:,:), 1));
	x.inbg = mean(x.intot([1:50 150:end],:), 1);
	x.in = x.intot - x.inbg;
	c = cumsum(x.in);
	c = c ./ max(c);
	idx = (1:size(x.in, 1))';
	x.dbounds = [];
	for k = 1:size(x.in, 2)
		x.dbounds(:,k) = interp1(c(:,k), idx, [0.1 0.9]);
	end
	x.dpx = diff(x.dbounds);
	caliper.X(end+1) = x;
endfor

caliper.d = vertcat(caliper.X.d);
caliper.dd = repelem(caliper.d, [caliper.X.N]');
caliper.dpx = [caliper.X.dpx]';

p = polyfit(caliper.dd, caliper.dpx, 1);
caliper.dfit = p;
caliper.pxpermm = p(1);
printf("image scale: %f px/mm\n", caliper.pxpermm);
