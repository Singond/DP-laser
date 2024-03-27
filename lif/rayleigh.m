pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;
addpath octave;

unidark = "data-2023-01-20/rayleigh_dark.SPE";

R = struct([]);
x = load_iccd("data-2023-01-20/rayleigh1.SPE", "dark", unidark);
x.amp = 50;
R(end+1) = x;
x = load_iccd("data-2023-01-20/rayleigh2.SPE", "dark", unidark);
x.amp = 30;
R(end+1) = x;
x = load_iccd("data-2023-01-20/rayleigh3.SPE", "dark", unidark);
x.amp = 20;
R(end+1) = x;
x = load_iccd("data-2023-01-20/rayleigh4.SPE", "dark", unidark);
x.amp = 10;
R(end+1) = x;

R = arrayfun(@correct_iccd, R);
R = arrayfun(@normalize_intensity, R);
R = arrayfun(@(x) frame_pulse_energy(x, 50), R);
R = arrayfun(@frame_pulse_energy, R);

Rold = R;
R = struct([]);
for x = Rold
	x.Em = mean(x.E);
	x.inm = mean(x.in, 3);
	x.in_overall = mean(x.inm(:));
	x.iny = sum(x.inm, 2);
	R(end+1) = x;
endfor

Rt = load_iccd("data-2023-01-20/rayleigh_cas.SPE", "dark", unidark);
Rt.t = 100:0.5:130;
Rt.amp = 50;
Rt = correct_iccd(Rt);
Rt = normalize_intensity(Rt);
Rt = frametimes(Rt, 50);
Rt = frame_pulse_energy(Rt);
Rt.iny = squeeze(sum(Rt.in, 2));
