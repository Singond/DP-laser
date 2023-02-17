fig = 1;

figure(fig++);
clf;
title("Spectral profile");
xlabel("wavelength \\lambda [nm]");
ylabel("intensity [a.u.]");
hold on;
for x = X([1:5])
	plot(x.wl, x.in ./ mean(x.E(:,1)),
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;

figure(fig++);
clf;
title("Spectral profile (with spatial filter)");
xlabel("wavelength \\lambda [nm]");
ylabel("intensity [a.u.]");
hold on;
for x = X([6:end])
	plot(x.wl, x.in ./ mean(x.E(:,1)),
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;
