pkg load singon-plasma;
addpath octave;

if (!exist("saturation", "var") || !isfield(saturation, "lifsm"))
	if (isfile("results/saturation.bin"))
		load results/saturation.bin
		if (isolderthan("results/saturation.bin", "saturation_full.m"))
			warning("loading saturation data from file older than script");
		end
	else
		saturation_full;
	end
end


figure("name", "Beam profile");
title("Beam profile at various energies");
Lscale = 1e6;
hold on;
k = 1;
for x = saturation(1:min(2,end));
	color = get(gca, "colororder")(k++,:);
	xx = repmat(x.ypos, 1, length(x.E));
	yy = repmat(x.E', length(x.ypos), 1) * Lscale;
	zz = squeeze(x.Ly) * Lscale;
	plot3(xx, yy, zz, "color", color);
end

for k = 1:length(beamprofile_L)
	plot3(x.ypos,...
		beamprofile_L(k) * ones(size(x.ypos)) * Lscale,...
		beamprofile(x.ypos,k) * beamprofile_L(k) * Lscale,...
		"color", [0 0 0], "linewidth", 4);
end
hold off;
view(37.5, 30);
xlabel("vertical position y [px]");
ylabel("total laser pulse energy L [\\mu{}J]");
zlabel("laser intensity L_y [\\mu{}J/px]");

