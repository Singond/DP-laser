pkg load singon-plasma;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifsm"))
	if (isfile("results/saturation.bin"))
		load results/saturation.bin
		if (isolderthan("results/saturation.bin", "saturation_full.m"))
			warning("loading saturation data from file older than script");
		end
	else
		saturation_full;
	end
end
x = saturation(3);
printf("Showing full-resolved saturation from set %s\n", x.name);

#warning("off", "Octave:negative-data-log-axis");
#warning("off", "Octave:imshow-NaN");

f_F = figure("name", "Reference image");
maxin = quantile(x.lif(:), 0.98);
imshow(x.lif(:,:,24), [0 maxin], "colormap", ocean,
	"xdata", x.xpos, "ydata", x.ypos);
title("Reference image");
axis on;
grid off;

f_alpha = figure("name", "Proportionality parameter");
ax = axes("position", [0.1 0.2 0.8 0.65]);
axes(ax);
ascale = 1e-9;
maxa = quantile(x.fite.a(:), 0.98);
imshow(x.fite.a * ascale, [0 maxa] * ascale, "colormap", pink,
	"xdata", x.xpos, "ydata", x.ypos);
title(sprintf('Proportionality parameter \\alpha [10^{%d}]', -log10(ascale)));
axis on;
grid off;
cb = colorbar("SouthOutside");

f_beta = figure("name", "Saturation parameter");
ax = axes("position", [0.1 0.2 0.8 0.65]);
axes(ax);
bscale = 1e-6;
bcenter = x.fite.b(round(end/4):round(3*end/4),round(end/4):round(3*end/4));
maxb = quantile(bcenter(:), 0.98);
imshow(x.fite.b * bscale, [0 maxb] * bscale, "colormap", ocean,
	"xdata", x.xpos, "ydata", x.ypos);
axis on;
grid off;
title(sprintf('Saturation parameter \\beta [10^{%d}]', -log10(bscale)));
cb = colorbar("SouthOutside");

f2 = figure("visible", "off");
f3 = figure("visible", "off");

function inspect_fit(s, fits, f_beta, f2, f3)
	figure(f_beta);
	[x, y, btn] = ginput(1);
	xr = round(x);
	yr = round(y);

	if (yr > max(s.ypos(:)) || yr < min(s.ypos(:))...
		|| xr > max(s.xpos(:)) || xr < min(s.ypos(:)))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_saturation(s, fits, yr, xr);
	hold off;

##	figure(f3, "name", "Fit detail (log)", "visible", "on");
##	set(gca, "yscale", "log");
##	hold on;
##	show_fit_saturation(s, fits, yr, xr);
##	hold off;
end

figure(f_beta);
uicontrol("parent", f_beta, "string", "Inspect fit", "position", [10 10 120 30],
	"callback", @(a,b) inspect_fit(x, [], f_beta, f2, f3));
uicontrol("parent", f_beta, "string", "Clear fits", "position", [140 10 120 30],
	"callback", @(a,b) clear_figs([f2, f3]));
