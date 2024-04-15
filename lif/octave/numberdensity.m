function n = numberdensity(C)
	global lightspeed;
	global planck;

	[~, imax] = max(C.E);
	Mf = C.lif(:,:,imax);
	Lf = C.E(imax);

	## Line properties
	lifeff = C.cameraeff.at_wavelen(C.liflines.wl);
	lineprops = sum(C.liflines.wl .* C.liflines.A32...
		.* C.liflines.B13 .* lifeff);

	photoncount = C.Lr * C.rayleigh_wl / (planck * lightspeed);
	lifrelative = Mf .* C.beta...
		./ (2 * (1 - log(1 + C.beta .* Lf) ./ C.beta .* Lf));

	n = 4 * pi * C.rayleigh_eff...
		.* (C.densair ./ C.Mr)...
		.* photoncount .* C.rayleigh_dxsect...
		.* (lightspeed / (C.kappa * lineprops))...
		.* lifrelative ./ C.tau;
end
