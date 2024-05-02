addpath ../octave

p1 = [138 138 147 210 280 420 795 1475 2680 4800 9750 20200 41500 63750 93800];
p2 = [232 228 355 460 705 975 1285 nan(1, 8)];
t = [{70:2:190} repmat({80:2:200}, 1, 13), {80:1:140}];

D = struct;
for k = [1:10 12:15]
	d = load_iccd(sprintf("data-2022-08-18/lifetime-%d.SPE", k));
	d.p1 = p1(k);
	d.p2 = p2(k);
	d.t = t{k}(:);
	D(k) = d;
end
## Series 6 has no power data, use previous
D(6).pwrdata = D(5).pwrdata;
## Missing series 11 data altogether, skip it
D = D([1:10 12:15]);

lifetimebase = D;
