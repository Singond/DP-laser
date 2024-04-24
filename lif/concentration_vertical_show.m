if (!exist("vertical", "var") || !all(isfield(vertical, {"ins", "n"})))
	concentration_vertical;
end

nscale = 1;
cmap = viridis;

figure("name", "Concentration in whole flame");
x = vertical(2);
maxn = quantile(x.n(:), 0.999);
imshow(x.n * nscale, [0 maxn] * nscale, "colormap", cmap,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("Se concentration in whole flame\n775 sccm Ar + 300 sccm H_2");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;

figure("name", "Concentration in whole flame");
x = vertical(3);
maxn = quantile(x.n(:), 0.999);
imshow(x.n * nscale, [0 maxn] * nscale, "colormap", cmap,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("Se concentration in whole flame\n175 sccm Ar + 150 sccm H_2");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;

figure("name", "Concentration in whole flame");
x = vertical(4);
maxn = quantile(x.n(:), 0.999);
imshow(x.n * nscale, [0 maxn] * nscale, "colormap", cmap,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("Se concentration in whole flame\n175 sccm Ar + 50 sccm H_2");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;

figure("name", "Concentration in centre of flame (0-2 mm from axis)");
clf;
hold on;
for x = vertical
	plot(x.ys, x.nc * nscale, "d",
		"displayname", sprintf("%d sccm Ar + %d H_2", x.sccmAr, x.sccmH2));
end
title("Se concentration in central part of flame");
xlabel("position y [mm]");
ylabel("concentration n [m^{-3}]");
legend show;

figure("name", "Concentration in flame edge (2-4 mm from axis)");
clf;
hold on;
for x = vertical
	plot(x.ys, x.nr * nscale, "d",
		"displayname", sprintf("%d sccm Ar + %d H_2", x.sccmAr, x.sccmH2));
end
title("Se concentration in right edge part of flame");
xlabel("position y [mm]");
ylabel("concentration n [m^{-3}]");
legend show;
