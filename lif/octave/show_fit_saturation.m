function show_fit_saturation(s, fits, ypos, xpos)
	if (!isempty(ypos))
		yidx = find(s.ypos == ypos);
	else
		yidx = 1;
	end
	if (!isempty(xpos))
		xidx = find(s.xpos == xpos);
	else
		xidx = 1;
	end

	#warning("off", "Octave:negative-data-log-axis", "local");
	Escale = 1e6;
	if (!isempty(ypos))
		L = s.Ly;
		lif = s.lif;
		fitl = s.fitl;
		fite = s.fite;
	else
		L = s.L;
		lif = s.lifx;
		fitl = s.fitlx;
		fite = s.fitex;
	end
	[Lmin, Lmax] = bounds(L);
	LL = linspace(Lmin, Lmax);
	c = get(gca, "colororder")(get(gca, "colororderindex"),:);
	plot(L * Escale, lif(yidx,xidx,:), "d",
			"color", c,
			"displayname", label_fit(s, {yidx, xidx}, {ypos, xpos}, fite),
		LL * Escale, fitl.f(yidx, xidx, LL),
			"b:", "color", c, "handlevisibility", "off",
		LL * Escale, fite.f(yidx, xidx, LL),
			"b--", "color", c, "handlevisibility", "off");
	hleg = legend;
	set(hleg, "interpreter", "tex");
	xlabel("energy E [uJ]");
	ylabel("LIF intensity I [a.u.]");

	if (compare_versions(version, "5.2.0", "<="))
		legend("location", "default", "orientation", "default");
	end
end

function l = label_fit(s, idx, pos, fit)
	subs_str = sprintf("%d,", cell2mat(pos))(1:end-1);
	l = sprintf("[%s] \\alpha = %.2fx10^9 \\beta = %.2fx10^6",
		subs_str, fit.a(idx{:})*1e-9, fit.b(idx{:})*1e-6);
end
