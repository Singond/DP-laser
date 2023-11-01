## -*- texinfo -*-
## @deftypefn  {} {} show_fit_decay (@var{s}, @var{fit}, @var{r}, @var{c})
## @deftypefnx {} {} show_fit_decay (@dots{}, @var{field})
##
## Inspect the fit produced by @code{fit_decay}.
## @end deftypefn
function show_fit_decay(s, fit, r, c, field="fite")
	x = s.t;
	y = s.in(r,c,:);

	[xmin, xmax] = bounds(x);
	[ymin, ymax] = bounds(y);

	xx = linspace(xmin, xmax);
	yl = fit(r,c).fitl.f(xx);    # linear fit in log scale
	ye = fit(r,c).fite.f(xx);    # exponential fit
	taue = fit(r,c).fite.tau;

	## Limit fitted functions to similar y-range as data
	if (strcmp(get(gca, "yscale"), "log"))
		ymin = min(y(y > 0));
		ml = (ymin * 0.1) < yl & yl < (ymax * 10);
		me = (ymin * 0.1) < ye & ye < (ymax * 10);
	else
		yrange = ymax - ymin;
		ml = (ymin - 0.1 * yrange) < yl & yl < (ymax + 0.1 * yrange);
		me = (ymin - 0.1 * yrange) < ye & ye < (ymax + 0.1 * yrange);
	end

	cidx = get(gca(), "colororderindex");
	cc = get(gca(), "colororder")(cidx,:);
	xscale = 1e9;
	plot(
		x * xscale, y, "bd",
			"color", cc, "displayname",
			sprintf("[%d, %d] \\tau_e = %.3f ns", r, c, taue * xscale),
		xx(ml) * xscale, yl(ml),
			"b:", "color", cc, "handlevisibility", "off",
		xx(me) * xscale, ye(me),
			"--", "color", cc, "handlevisibility", "off");
	xlabel("time t [ns]");
	ylabel("inensity I [a.u.]");

	hleg = legend;
	set(hleg, "interpreter", "tex");
	## Compatibility hack for older Octave versions (tested on 5.2.0):
	## Set location and orientation explicitly to "default" to force
	## an update of the legend from current "displayname" properties.
	## This is not necessary in newer versions, where the legend is
	## updated automatically.
	if (compare_versions(version, "5.2.0", "<="))
		legend("location", "default", "orientation", "default");
	end
end
