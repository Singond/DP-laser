pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
if (isfolder("../octave-local"))
	addpath ../octave-local;
end

X = struct();
k = 1;
#X(k++) = load_iccd("data-2023-01-18/saturation1.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation3.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturationBlankA.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation4.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation5.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation6.SPE");
X(k++) = load_iccd("data-2023-01-18/saturation7.SPE");
X(k++) = load_iccd("data-2023-01-18/saturation8.SPE");
X(k++) = load_iccd("data-2023-01-18/saturation9.SPE");

function x = process(x)
	x.inraw = squeeze(sum(sum(x.img, 1), 2));
	x.in = x.inraw ./ (x.acc);
end

## TODO: Change camera and powermeter delay to 0, because the
## synchronization is now done precisely by computer during measurement.
## (Also in previous TALIF measurement in January.)
#m = [4:5];
#X(m) = arrayfun(@(x) crop_iccd(x, [140 180], [461 504]), X(m));
X = arrayfun(@correct_iccd, X);
X = arrayfun(@(x) frametimes(x, 50), X);
X = arrayfun(@process, X);
