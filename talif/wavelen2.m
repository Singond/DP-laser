pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

wl = 204.12:0.001:204.18;
amp = [50 50 15 20 30 40];

# Select and order used files.
# First dataset aborted due to laser error.
nfile = [3:6 2];

D = struct;
for k = 1:numel(nfile)
	n = nfile(k);
	d.filename = sprintf("data-2023-01-09/sken%d-204_12-204_18.SPE", n);
	d = load_iccd(d.filename);
    d.wl = wl;
	d.amp = amp(n);
	D(k) = d;
end
D = arrayfun(@(x) crop_iccd(x, [25 90], [50 410]), D);


function x = process(x)
	sum2 = sum(x.img, 2);
	x.inraw = squeeze(sum(sum2, 1));
	x.in = x.inraw ./ (x.E * x.acc);
	x.beamt = squeeze(sum2);
	x.beami = sum(sum2, 3);
end

X = arrayfun(@correct_iccd, D);
X = arrayfun(@(x) frametimes(x, 50), X);
X = arrayfun(@frame_pulse_energy, X);
X = arrayfun(@process, X);
