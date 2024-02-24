function show_fit_decay(s, fits, ypos, xpos)
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

	offsetsubs = {ypos, xpos};
	warning("off", "Octave:negative-data-log-axis", "local");
	plot_fit_decay(s, fits, "idx", {yidx, xidx},
		"dim", 3, "label", @(fit, subs) label_fit(fit, offsetsubs));
	hleg = legend;
	set(hleg, "interpreter", "tex");
	xlabel("time t [ns]");
	ylabel("inensity I [a.u.]");
end

function l = label_fit(fit, subs)
	subs_str = sprintf("%d,", cell2mat(subs))(1:end-1);
	l = sprintf("[%s] \\tau_e = %.3f ns", subs_str, fit.fite.tau);
end
