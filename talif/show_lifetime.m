if (!exist("X"))
	lifetime;
end

figure;
title("Time evolution of intensity");
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
