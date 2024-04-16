function n = numberdensity(C, frame="all")
	global lightspeed;
	global planck;

	if (ischar(frame) && strcmp(frame, "max"))
		[~, frame] = max(C.E);
	end

	if (ischar(frame) && strcmp(frame, "all"))
		Mf = C.lif;
		Lf = reshape(C.E, 1, 1, []);
	elseif (isnumeric(frame) && !isempty(frame))
		Mf = C.lif(:,:,frame);
		Lf = C.E(frame);
	else
		error("numberdensity: frame must be a number");
	end

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
