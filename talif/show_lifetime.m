if (!exist("X"))
	lifetime;
end

figure;
title("Time evolution of intensity");
xlabel("time t[ns]");
ylabel("intensity [a.u.]");
hold on;
k = 1;
for x = X
	set(gca, "colororderindex", k);
	plot(x.t, x.in,
		"displayname", sprintf("%d Pa", x.p1));

	tt = linspace(min(x.t), max(x.t), 1000);
	set(gca, "colororderindex", k);
	plot(tt, x.fite.f(tt), "--", "handlevisibility", "off");

	set(gca, "colororderindex", k);
	plot(tt, x.fitb.f(tt), ":", "handlevisibility", "off");

	k++;
end
hold off;
legend location northeast;

figure;
title("Time evolution of intensity (normalized)");
xlabel("time t [ns]");
ylabel("intensity [a.u.]");
hold on;
k = 1;
for x = X
	c = max(x.in);
	set(gca, "colororderindex", k);
	plot(x.t, x.in ./ c,
		"displayname", sprintf("%d Pa", x.p1));

	tt = linspace(min(x.t), max(x.t), 1000);
	set(gca, "colororderindex", k);
	plot(tt, x.fite.f(tt) ./ c, "--", "handlevisibility", "off");

	set(gca, "colororderindex", k);
	plot(tt, x.fitb.f(tt) ./ c, ":", "handlevisibility", "off");

	k++;
end
hold off;
legend location northeast;

figure;
semilogx([X.p1]', [[X.fitl].tau]', "d", "displayname", "linear fit",...
	[X.p1]', [[X.fite].tau]', "o", "displayname", "exponential fit",...
	[X.p1]', [[X.fitb].tau]', "s",...
		"markersize", 7,...
		"displayname", "exponential fit with constant");
title("Lifetime by various methods");
xlabel("pressure p [Pa]");
ylabel("lifetime \\tau [ns]");
legend show;
legend location northwest;
