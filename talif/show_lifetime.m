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
xlabel("time t[ns]");
ylabel("intensity [a.u.]");
hold on;
for x = X
	plot(x.t, x.in ./ max(x.in),
		"displayname", sprintf("%d Pa", x.p1));
end
hold off;
legend location northeast;

figure;
plot([X.p1]', [[X.fitl].tau]', "d",
	[X.p1]', [[X.fite].tau]', "o",
	[X.p1]', [[X.fitb].tau]', "s");
