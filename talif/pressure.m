pkg load optim;
pkg load singon-plasma;
addpath octave

p1 = [138 136 149 308  830  5770 5820 26000];
p2 = [226 222 406 775 1260 nan(1, 3)];
t = repmat({70:2:190}, 8, 1);

function x = process_pressure(x)
	x.inraw = squeeze(sum(sum(x.img, 1), 2));
	x.in = x.inraw ./ (x.E * x.acc);
end


D = struct;
for k = [1:5 7]
	d = load_iccd(sprintf("data-2022-08-15/pressure-%d.SPE", k));
	d.p1 = p1(k);
	d.p2 = p2(k);
	d.t = t{k}(:);
	D(k) = d;
end
D(6) = [];  # Aborted measurement

D = arrayfun(@(x) crop_iccd(x, [148 167], [220 779]), D);
X = arrayfun(@correct_iccd, D);
X = arrayfun(@process_pressure, X);
