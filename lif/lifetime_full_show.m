if (!exist("lifetime", "var"))
	lifetime_full;
end

warning("off", "Octave:negative-data-log-axis");
warning("off", "Octave:imshow-NaN");

f1 = figure("name", "Lifetime");
ax = axes("position", [0.1 0.2 0.8 0.65]);
axes(ax);
maxtau = quantile(tau(:), 0.95);
imshow(tau, [0 maxtau], "colormap", ocean,
	"xdata", x.aoi.cols, "ydata", x.aoi.rows);
axis on;
set(ax, "ticklength", [0 0])
grid off;
title('lifetime \tau [ns]', "interpreter", "tex");
cb = colorbar("SouthOutside");

f2 = figure("visible", "off");
f3 = figure("visible", "off");

function inspect_fit(s, fits, f1, f2, f3)
	figure(f1);
	[x, y, btn] = ginput(1);
	xr = round(x) - s.aoi.cols(1) + 1;
	yr = round(y) - s.aoi.rows(1) + 1;

	if (yr > size(fits, 1) || xr > size(fits, 2))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_decay(s, fits, yr, xr);
	hold off;

	figure(f3, "name", "Fit detail (log)", "visible", "on");
	set(gca, "yscale", "log");
	hold on;
	show_fit_decay(s, fits, yr, xr);
	hold off;
end

function clear_figs(figs)
	for f = figs
		clf(f)
	end
end

figure(f1);
uicontrol("parent", f1, "string", "Inspect fit", "position", [10 10 120 30],
	"callback", @(a,b) inspect_fit(x, fits, f1, f2, f3));
uicontrol("parent", f1, "string", "Clear fits", "position", [140 10 120 30],
	"callback", @(a,b) clear_figs([f2, f3]));
