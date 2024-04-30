wavelen2;

fig = 1;
figure(fig++);
clf;
hold on;
for x = X
	plot(x.wl, x.in, "d-",
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;
title("Spectral profile");
xlabel("wavelength \\lambda [nm]");
ylabel("signal I [a.u.]");
legend location northeast;

figure(fig++);
clf;
x = X(1);
k = 1:5:size(x.beamt, 2);
beamt = x.beamt(:,k);
bnorm = max(beamt);
plot(beamt, "-");
title("Beam profile vs wavelength");
xlabel("y [px]");
ylabel("signal I [a.u.]");
l = arrayfun(@(x) sprintf("%.3f nm", x), x.wl(k), "UniformOutput", false);
legend(l);
legend location northeast;

figure(fig++);
clf;
hold on;
for x = X
	plot(x.beami, "d",
		"displayname", sprintf("amp %d", x.amp));
endfor
hold off;
title("Beam profile vs intensity");
xlabel("y [px]");
ylabel("signal I [a.u.]");
legend location northeast;
