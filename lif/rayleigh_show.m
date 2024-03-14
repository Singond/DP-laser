if (!exist("R", "var"))
	rayleigh;
end

figure(1, "name", "Example image");
clf;
imshow(R(1).img(:,:,1), []);
title("Rayleigh scattering example image");

figure(2, "name", "Overall intensity");
clf;
plot([R.Em]*1e6, [R.inm], "d");
title("Rayleigh scattering overall intensity");
xlabel("laser power E [\\muJ]");
ylabel("intensity I [a.u.]");

figure(3, "name", "Time evolution");
clf;
plot(Rt.t, Rt.in);
title("Rayleigh scattering time evolution");
xlabel("time t [ns]");
ylabel("intensity I [a.u.]");

figure(4, "name", "Beam profile");
clf;
hold on;
for r = R
	plot(r.iny, "d", "displayname", sprintf("L = %.3g \\muJ", r.Em*1e6));
end
hold off;
title("Beam vertical profile");
xlabel("vertical position y [px]");
ylabel("intensity I [a.u.]");
legend show;
