saturation_overall;

Escale = 1e6;
k = 1;
hold on;
for x = saturation;
	plot(x.E * Escale, x.in, "-d");
end
hold off;
