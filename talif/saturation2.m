pkg load optim;
pkg load singon-plasma;

p = [2400 2400];
#p2 = [226 222 406 775 1260 nan(1, 3)];
t = 70;

function x = process(x)
	x.inraw = squeeze(sum(sum(x.img, 1), 2));
	x.in = x.inraw ./ (x.E * x.acc);
end


D = struct;
for k = [1:2]
	d = load_iccd(sprintf("data-2023-01-09/saturation-%d.SPE", k));
	d.p = p(k);
	d.t = t;
	D(k) = d;
end

X = arrayfun(@(x) crop_iccd(x, [25 90], [50 410]), D);
X = arrayfun(@(x) frametimes(x, 50), X);
X = arrayfun(@frame_pulse_energy, X);
X = arrayfun(@correct_iccd, X);
X = arrayfun(@process, X);
