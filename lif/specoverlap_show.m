specoverlap_main;

p = specoverlap.profiles(1);

plot(p.ff, p.l,
		"displayname", "laser",
	p.ff, p.la,
		"displayname", "measured (laser + absorption)",
	p.freq, p.lawl,
		"displayname", "measured in wavelength representation");
title("Comparison of spectral profiles");
axis([1528 1530.5]);
xlabel("frequency [THz]");
ylabel("normed intenzity [THz-1]");
legend show;
