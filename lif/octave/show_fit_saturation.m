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
	plot(s.E * Escale, s.in(yidx,xidx,:), "-d",
		"displayname", label_fit({ypos, xpos}));
	hleg = legend;
	set(hleg, "interpreter", "tex");
	xlabel("energy E [uJ]");
	ylabel("LIF intensity I [a.u.]");

	if (compare_versions(version, "5.2.0", "<="))
		legend("location", "default", "orientation", "default");
	end
end

function l = label_fit(subs)
	subs_str = sprintf("%d,", cell2mat(subs))(1:end-1);
	l = sprintf("[%s] \\beta = %.3f", subs_str, 0);
end
