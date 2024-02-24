function show_fit_decay(varargin)
	s = varargin{1};
	offset = [s.aoi.rows(1) - 1, s.aoi.cols(1) - 1];
	plot_fit_decay(varargin{1:2}, "idx", varargin(3:end),
		"dim", 3, "label", @(fit, subs) label_fit(fit, subs, offset));
	hleg = legend;
	set(hleg, "interpreter", "tex");
	xlabel("time t [ns]");
	ylabel("inensity I [a.u.]");
end

function l = label_fit(fit, subs, offset)
	subs = cell2mat(subs) + offset;
	subs_str = sprintf("%d,", subs)(1:end-1);
	l = sprintf("[%s] \\tau_e = %.3f ns", subs_str, fit.fite.tau);
end
