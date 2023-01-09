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
t = 1:5:size(x.beamt, 2);
beamt = x.beamt(:,t);
bnorm = max(beamt);
plot(beamt ./ bnorm, "-");
title("Beam profile in time (normalized)");
xlabel("y [px]");
ylabel("signal I [a.u.]");
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
