if (!exist("vertical", "var") || !isfield(saturation, "ins"))
	vertical_full;
end


nscale = 1;

figure("name", "Concentration in whole flame");
x = vertical(2);
maxn = quantile(x.n(:), 0.999);
imshow(x.n * nscale, [0 maxn] * nscale, "colormap", viridis,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("Se concentration in whole flame\n700 sccm Ar + 300 sccm H_2");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;

figure("name", "Concentration in whole flame");
x = vertical(3);
maxn = quantile(x.n(:), 0.999);
imshow(x.n * nscale, [0 maxn] * nscale, "colormap", viridis,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("Se concentration in whole flame\n175 sccm Ar + 150 sccm H_2");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;
