pkg load singon-plasma;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "fita"))
	alpha_full;
end

x = saturation(3);

f_alpha2 = figure("name", "Proportionality parameter");
ax = axes("position", [0.1 0.2 0.8 0.65]);
axes(ax);
ascale = 1e-9;
maxa = quantile(x.fita.a(:), 0.98);
imshow(x.fita.a * ascale, [0 maxa] * ascale, "colormap", pink,
	"xdata", x.xpos, "ydata", x.ypos);
title(sprintf(...
	'Proportionality parameter \\alpha [10^{%d}]\n\\beta=%g \\mu{}J^{-1}',...
	-log10(ascale), x.beta * 1e-6));
axis on;
grid off;
cb = colorbar("SouthOutside");

f_alpha2_fit = figure("visible", "off");

function inspect_fit(s, f_alpha2, f2)
	figure(f_alpha2);
	[x, y, btn] = ginput(1);
	xr = round(x);
	yr = round(y);

	if (yr > max(s.ypos(:)) || yr < min(s.ypos(:))...
		|| xr > max(s.xpos(:)) || xr < min(s.ypos(:)))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_alpha(s, yr, xr);
	hold off;
end

figure(f_alpha2);
uicontrol("parent", f_alpha2, "string", "Inspect fit", "position", [10 10 120 30],
	"callback", @(a,b) inspect_fit(x, f_alpha2, f_alpha2_fit));
uicontrol("parent", f_alpha2, "string", "Clear fits", "position", [140 10 120 30],
	"callback", @(a,b) clear_figs(f_alpha2_fit));
