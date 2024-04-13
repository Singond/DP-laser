pkg load singon-plasma;
addpath octave;

if (!exist("lifetime", "var"))
	if (isfile("results/lifetime.bin"))
		load results/lifetime.bin
		if (isolderthan("results/lifetime.bin", "lifetime_full.m"))
			warning("loading lifetime data from file older than script");
		end
	else
		lifetime_full;
	end
end
x = lifetime;

warning("off", "Octave:negative-data-log-axis");
warning("off", "Octave:imshow-NaN");

f1 = figure("name", "Lifetime");
ax = axes("position", [0.1 0.2 0.8 0.65]);
axes(ax);
maxtau = quantile(x.tau(:), 0.95);
imshow(x.tau, [0 maxtau], "colormap", ocean,
	"xdata", x.xpos, "ydata", x.ypos);
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
	xr = round(x);
	yr = round(y);

	if (yr > max(s.ypos(:)) || yr < min(s.ypos(:))...
		|| xr > max(s.xpos(:)) || xr < min(s.ypos(:)))
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

figure(f1);
uicontrol("parent", f1, "string", "Inspect fit", "position", [10 10 120 30],
	"callback", @(a,b) inspect_fit(x, x.fits, f1, f2, f3));
uicontrol("parent", f1, "string", "Clear fits", "position", [140 10 120 30],
	"callback", @(a,b) clear_figs([f2, f3]));
