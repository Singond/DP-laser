pkg load singon-plasma;
addpath ../lif/octave;

lifetime_load;
x = lifetime(1);

fig_inx = figure("name", "Time evolution along x");
surf(x.xpos, x.t, squeeze(x.inx)');
title("Time evolution of intensity summed along y");
set(gca, "ydir", "reverse");
xlabel("position x [px]");
ylabel("time t[ns]");
zlabel("intensity I_x [a.u.]");
view(-75, 20);

fig_taux = figure("name", "Lifetime along x");
title("Lifetime along x");
errorbar(x.xpos, x.taux, x.tausigx, "d");
xlim([min(x.xpos) max(x.xpos)]);
ylim([0 2*quantile(x.taux, 0.99)]);
xlabel("position x [px]");
ylabel('lifetime \tau_e [ns]', "interpreter", "tex")

fig_fit = figure("visible", "off");
fig_logfit = figure("visible", "off");

function inspect_fitx(s, fits, f1, f2, f3)
	figure(f1);
	[x, y, btn] = ginput(1);
	xr = round(x);

	if (xr > max(s.xpos(:)) || xr < min(s.ypos(:)))
		return;
	end

	figure(f2, "name", "Fit detail", "visible", "on");
	hold on;
	show_fit_decay(s, fits, [], xr);
	hold off;

	figure(f3, "name", "Fit detail (log)", "visible", "on");
	set(gca, "yscale", "log");
	hold on;
	show_fit_decay(s, fits, [], xr);
	hold off;
end

figure(fig_taux);
s = x;
s.in = x.inx;
uicontrol("parent", fig_taux,
	"string", "Inspect fit",
	"position", [10 10 120 30],
	"callback", @(a,b) inspect_fitx(s, x.fitsx, fig_taux, fig_fit, fig_logfit));
uicontrol("parent", fig_taux,
	"string", "Clear fits",
	"position", [140 10 120 30],
	"callback", @(a,b) clear_figs([fig_fit, fig_logfit]));

figure("name", "Lifetime for various pressures");
hold on;
for x = lifetime
	plot(x.xpos, x.taux, "-",...
		"displayname", sprintf("%.0f Pa", x.p1));
end
title("Lifetime for various pressures");
xlabel("position x [px]");
ylabel('lifetime \tau [ns]');
legend show;
legend location northwest;
xlabel("position x [px]");
