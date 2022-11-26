if (!exist("X"))
	pressure;
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
	k++;
end
hold off;
legend location northeast;

