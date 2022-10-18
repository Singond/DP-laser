if (!exist("X"))
	lifetime;
end

figure;
title("Time evolution of intensity");
xlabel("time t[ns]");
ylabel("intensity [a.u.]");
hold on;
k = 1;
for x = X(1:5)
	set(gca, "colororderindex", k);
	plot(x.t, x.in,
		"displayname", sprintf("%d Pa", x.p1));

	tt = linspace(min(x.t), max(x.t));
	set(gca, "colororderindex", k);
	plot(tt, x.fite.f(tt), "--", "handlevisibility", "off");

	tt = linspace(min(x.t), max(x.t));
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
plot([X.p1]', [X.tau]', "d");
