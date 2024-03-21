fig = 1;

figure(fig++);
clf;
title("Spectral profile");
xlabel("wavelength \\lambda [nm]");
ylabel("intensity [a.u.]");
hold on;
for x = W([1:5])
	plot(x.wl, x.in ./ x.Em,
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;
legend show;

figure(fig++);
clf;
title("Spectral profile (with spatial filter)");
xlabel("wavelength \\lambda [nm]");
ylabel("intensity [a.u.]");
hold on;
for x = W([6:end])
	plot(x.wl, x.in ./ x.Em,
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;
legend show;
