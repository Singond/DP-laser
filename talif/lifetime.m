pkg load singon-plasma;

addpath ../octave
addpath ../octave-local

warning off Octave:possible-matlab-short-circuit-operator
warning off Octave:negative-data-log-axis

p1 = [138 138 147 210 280 420 795 1475 2680 4800 9750 20200 41500 63750 93800];
p2 = [232 228 355 460 705 975 1285 nan(1, 8)];
t = [{70:2:190} repmat({80:2:200}, 1, 13), {80:1:140}];

function x = load_data(data, dark = "", power = "", acc)
	[dir, name, ext] = fileparts(data);
	if (isempty(dark))
		dark = fullfile(dir, [name "_dark" ext]);
	end
	if (isempty(power))
		power = fullfile(dir, [name ".txt"]);
	end

	[x.img, x.imgm] = read_princeton_spe(data);
	[x.dark, x.darkm] = read_princeton_spe(dark);
	[nframes, x.acc, x.readout] = hlavickaSPE(data); # Move to read_princeton_spe
	x.pwrdata = read_starlab(power);
end

function x = crop(x, rows, cols)
	x.img  = x.img (rows(1):rows(2), cols(1):cols(2), :);
	x.dark = x.dark(rows(1):rows(2), cols(1):cols(2), :);
end

function x = apply_corrections(x)
	## TODO: Eliminate outliers

	## Subtract dark frame
	x.dark = mean(x.dark, 3);
	x.img -= x.dark;

	E = dopln_pulzy(x.pwrdata(:,[2 1]));
	x.E = rozdel_energie(E, size(x.img, 3), x.acc, 1, x.readout)';
end

function x = process_lifetime(x)
	x.inraw = squeeze(sum(sum(x.img, 1), 2));
	x.in = x.inraw ./ (x.E * x.acc);

	x.fit.beta = polyfit(x.t, log(x.in), 1);
	x.tau = -1 / x.fit.beta(1);
end

D = struct;
for k = [1:10 12:15]
	d = load_data(sprintf("data-2022-08-18/lifetime-%d.SPE", k));
	d.p1 = p1(k);
	d.p2 = p2(k);
	d.t = t{k}(:);
	D(k) = d;
end
## Series 6 has no power data, use previous
D(6).pwrdata = D(5).pwrdata;
## Missing series 11 data altogether, skip it
D = D([1:10 12:15]);

D = arrayfun(@(x) crop(x, [143 167], [220 779]), D);
X = arrayfun(@apply_corrections, D);
X = arrayfun(@process_lifetime, X);
