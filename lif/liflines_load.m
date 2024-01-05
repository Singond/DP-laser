addpath ../octave;
constants;

data = [
	196.0258	6.0e6
	203.9851	6.5e6
	206.2788	6.6e6
	241.3509	9.4e6
	350.1515	3.0e6
];

liflines.wl = data(:,1);   # wavelength [nm]
liflines.A32 = data(:,2);  # Einstein coefficient of emission [s-1]
g1 = 5;
g3 = 3;
## XXX: Is it g3/g1 or g1/g3?
liflines.B13 = (g3 / g1) .* liflines.A32 .* (liflines.wl * 1e-9).^3 ./...
	(8 * pi * planck);