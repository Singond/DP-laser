addpath ../octave;
constants;

data = [
	196.0258	6.0e6	2
	203.9851	6.5e6	1
	206.2788	6.6e6	0
	241.3509	9.4e6	2
	350.1515	3.0e6	0
];

liflines.wl = data(:,1);            # wavelength [nm]
liflines.A32 = data(:,2);           # Einstein coefficient of emission [s-1]
liflines.J2 = data(:,3);            # total ang. momentum of lower state
liflines.g2 = 2 * liflines.J2 + 1;  # multiplicity of lower state
g3 = 3;

liflines.B23 = (g3 ./ liflines.g2) .* liflines.A32...
	.* (liflines.wl * 1e-9).^3 ./ (8 * pi * planck);
