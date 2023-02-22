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
#X(k++) = load_iccd("data-2023-01-18/saturation7.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation8.SPE");
#X(k++) = load_iccd("data-2023-01-18/saturation9.SPE");
X(k++) = load_iccd("data-2023-01-20/saturace1.SPE");
X(k++) = load_iccd("data-2023-01-20/saturace2.SPE");

X = arrayfun(@correct_iccd, X);
X = arrayfun(@(x) frametimes(x, 50), X);
X = arrayfun(@img_intensity, X);
X = arrayfun(@process, X);
