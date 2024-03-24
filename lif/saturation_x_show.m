pkg load singon-plasma;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifx"))
	saturation_x;
end
x = saturation(1);

f_alpha = figure("name", "Proportionality parameter");
ascale = 1e-9;
plot(x.xpos, x.fitex.a * ascale, "d");
title('Proportionality parameter \alpha');
xlabel("horizontal position x [px]");
ylabel(sprintf("proportionality parameter \\alpha [10^{%d}]", -log10(ascale)));

f_beta = figure("name", "Saturation parameter");
bscale = 1e-6;
plot(x.xpos, x.fitex.b * bscale, "d", "displayname", "x-resolved \\beta");
title('Saturation parameter \beta');
xlabel("horizontal position x [px]");
ylabel('saturation parameter \beta [\mu{}J^{-1}]');

f2 = figure("visible", "off");

function inspect_fit(s, fits, f_beta, f2)
	figure(f_beta);
	[x, y, btn] = ginput(1);
	xr = round(x);

	if (xr > max(s.xpos(:)) || xr < min(s.ypos(:)))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_saturation(s, fits, [], xr);
	hold off;
end

figure(f_beta);
uicontrol("parent", f_beta, "string", "Inspect fit", "position", [10 10 120 30],
	"callback", @(a,b) inspect_fit(x, [], f_beta, f2));
uicontrol("parent", f_beta, "string", "Clear fits", "position", [140 10 120 30],
	"callback", @(a,b) clear_figs([f2]));

if (exist("saturationt", "var"))
	figure(f_beta);
	hold on;
	plot(x.xpos, (saturationt.fite.b * bscale)(ones(size(x.xpos))),...
		"k--", "displayname", "integral \\beta");
	hold off;
	legend show;
end
