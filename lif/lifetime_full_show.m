if (!exist("lifetime", "var"))
	lifetime_full;
end

f1 = figure("name", "Lifetime");
imshow(tau, [0 1e-8], "colormap", ocean);
title('lifetime \tau [ns]', "interpreter", "tex");
colorbar SouthOutside;

f2 = figure("visible", "off");
f3 = figure("visible", "off");

function inspect_fit(s, fits, f1, f2, f3)
	figure(f1);
	[x, y, btn] = ginput(1);
	xr = round(x);
	yr = round(y);

	if (yr > size(fits, 1) || xr > size(fits, 2))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_decay(s, fits, yr, xr);
	hold off;

	figure(f3, "name", "Fit detail (log)", "visible", "on");
	warning("off", "Octave:negative-data-log-axis", "local");
	set(gca, "yscale", "log");
	hold on;
	show_fit_decay(s, fits, yr, xr);
	hold off;
end

figure(f1);
uicontrol(gcf, "string", "Inspect fit", "position", [40 40 160 40],
	"callback", @(a,b) inspect_fit(x, fits, f1, f2, f3));
