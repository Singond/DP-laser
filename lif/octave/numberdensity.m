function [n, s] = numberdensity(C, frame="all")
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

	lineprops = sum(C.liflines.wl .* C.liflines.A32...
		.* C.liflines.B23 .* C.liflines.eff .* C.liflines.T);

	s.photoncount = C.Lr * C.rayleigh_wl / (planck * lightspeed);
	s.lifrelative = Mf .* C.beta...
		./ (2 * (1 - log(1 + C.beta .* Lf) ./ C.beta .* Lf));

	n = 4 * pi * C.rayleigh_eff...
		.* (C.densair ./ C.Mr)...
		.* s.photoncount .* C.rayleigh_dxsect...
		.* (lightspeed / (C.kappa * lineprops))...
		.* s.lifrelative ./ C.tau;
end
