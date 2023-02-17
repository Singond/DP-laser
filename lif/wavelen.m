pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
if (isfolder("../octave-local"))
	addpath ../octave-local;
end

amp = [50 40 30 20 13 50 40 30 24 15];
wl = (195.95:0.001:196.2)';

D = struct();
k = 1;
D(k++) = load_iccd("data-2023-01-20/scan4.SPE");
D(k++) = load_iccd("data-2023-01-20/scan5.SPE");
D(k++) = load_iccd("data-2023-01-20/scan6.SPE");
D(k++) = load_iccd("data-2023-01-20/scan7.SPE");
D(k++) = load_iccd("data-2023-01-20/scan8.SPE");
D(k++) = load_iccd("data-2023-01-20/scan9.SPE");   # First set with spatial f.
D(k++) = load_iccd("data-2023-01-20/scan10.SPE");
D(k++) = load_iccd("data-2023-01-20/scan11.SPE");
D(k++) = load_iccd("data-2023-01-20/scan12.SPE");
D(k++) = load_iccd("data-2023-01-20/scan13.SPE");  # Swapped powermeters

X = struct();
for k = 1:length(D);
	x = D(k);
	x.amp = amp(k);
	x.wl = wl;
	X(k) = x;
end
clear D;

function x = process(x)
	x;
end

X = arrayfun(@correct_iccd, X);
X = arrayfun(@(x) frametimes(x, 25), X);
X = arrayfun(@img_intensity, X);
X = arrayfun(@process, X);
