if (!exist("R", "var"))
	rayleigh;
end

figure(1, "name", "Example image");
clf;
imshow(R(1).inm, []);
title("Rayleigh scattering example image");

figure(2, "name", "Overall intensity");
clf;
plot([R.Em]*1e6, [R.in_overall], "d");
title("Rayleigh scattering overall intensity");
xlabel("laser power E [\\muJ]");
ylabel("intensity I [a.u.]");

figure(3, "name", "Time evolution");
clf;
hold on;
set(gca, "colororder", winter);
set(gca, "colororder", lines(length(Rt.t)));
plot3(
	Rt.t(ones(size(Rt.ypos)),:),
	Rt.ypos(:,ones(size(Rt.t))),
	Rt.iny, "-");
hold off;
title("Rayleigh scattering time evolution");
view(3);
xlabel("time t [ns]");
ylabel("position y [px]");
zlabel("intensity I [a.u.]");
axis ij;
grid on;

figure(4, "name", "Beam profile");
clf;
hold on;
for r = R
	plot(r.iny, "-", "displayname", sprintf("L = %.3g \\muJ", r.Em*1e6));
end
hold off;
title("Beam vertical profile");
xlabel("vertical position y [px]");
ylabel("intensity I [a.u.]");
legend show;

figure(5, "name", "Beam profile (normalized)");
clf;
hold on;
for k = 1:columns(beamprofile)
	bpr = beamprofile(:,k);
	plot(bpr, "-",...
		"displayname", sprintf("L = %.3g \\muJ", beamprofile_L(k)*1e6));
end
hold off;
title("Beam vertical profile (normalized)");
xlabel("vertical position y [px]");
ylabel("normalized laser intensity L_n [px^{-1}]");
legend show;
