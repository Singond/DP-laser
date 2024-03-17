saturation_overall;

Escale = 1e6;
k = 1;
figure();
hold on;
for x = saturation_separate;
	plot(x.E * Escale, x.in, "-d");
end
hold off;
title("Intenzita LIF (integrál celého snímku)");
xlabel("energie E [\\mu{}J]");
ylabel("intenzita LIF F [a.u.]");
