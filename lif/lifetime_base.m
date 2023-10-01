pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

regions;

X = struct;
x = load_iccd("data-2023-01-20/decay1.SPE");
x.dt = 1e-9;
X(1) = x;

x = load_iccd("data-2023-01-20/decay2.SPE");
x.dt = 5e-10;
X(2) = x;

X = arrayfun(@correct_iccd, X);

lifetime = struct([]);
for x = X
	x.t = (0:x.imgm.numframes - 1)' * x.dt;
	lifetime(end+1) = x;
endfor
clear X
