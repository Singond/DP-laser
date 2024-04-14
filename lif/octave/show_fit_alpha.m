function show_fit_alpha(s, ypos, xpos)
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

	Escale = 1e6;
	L = s.Ly(yidx,:);
	lif = s.lifsm;
	[Lmin, Lmax] = bounds(L);
	LL = linspace(Lmin, Lmax);
	c = get(gca, "colororder")(get(gca, "colororderindex"),:);
	plot(L * Escale, lif(yidx,xidx,:), "d",
			"color", c,
			"displayname", label_fit(s, {yidx, xidx}, {ypos, xpos}, s.fita),
		LL * Escale, s.fita.f(yidx, xidx, LL),
			"b--", "color", c, "handlevisibility", "off");
	hleg = legend;
	set(hleg, "interpreter", "tex");
	xlabel('energy E [\mu{}J]');
	ylabel("LIF intensity I [a.u.]");

	if (compare_versions(version, "5.2.0", "<="))
		legend("location", "default", "orientation", "default");
	end
end

function l = label_fit(s, idx, pos, fit)
	subs_str = sprintf("%d,", cell2mat(pos))(1:end-1);
	l = sprintf("[%s] \\alpha = %.2fx10^9", subs_str, fit.a(idx{:})*1e-9);
end
