figure(1);
clf;
plot([R.Em]*1e6, [R.inm], "d");
title("Rayleigh scattering");
xlabel("laser power E [\\muJ]");
ylabel("intensity I [a.u.]");

figure(2);
clf;
plot(Rt.t, Rt.in);
title("Rayleigh scattering time evolution");
xlabel("time t [ns]");
ylabel("intensity I [a.u.]");
