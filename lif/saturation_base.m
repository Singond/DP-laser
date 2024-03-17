pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
if (isfolder("../octave-local"))
	addpath ../octave-local;
end

function result = merge_saturation_data(a)
	if (nargin < 1)
		error("merge_data: No argument");
	elseif (nargin > 1)
		error("merge_data: Too many arguments");
	elseif (!isstruct(a))
		error("merge_data: Argument must be a struct array");
	elseif (numel(a) == 1)
		result = a;
		return;
	end

	result = a(1);
	for s = a(2:end)
		assert(isequal(s.xpos, result.xpos), "different xpos");
		assert(isequal(s.ypos, result.ypos), "different xpos");
		assert(isequal(s.acc, result.acc), "different acc");
		result.img = cat(3, result.img, s.img);
		result.imgm = [result.imgm s.imgm];
		result.dark = cat(3, result.dark, s.dark);
		result.darkm = [result.darkm s.darkm];
		result.imgt = [result.imgt; s.imgt];
		result.pwrdata = [result.pwrdata; s.pwrdata];
		result.E = [result.E; s.E];
	end
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
X = arrayfun(@frame_pulse_energy, X);

#saturation = X;
saturation_separate = X;
saturation = merge_saturation_data(X(1:2));
