if (!exist("conc", "var") || !isfield(conc, "n"))
	concentration_main;
end

nscale = 1;

figure("name", "Density");
maxn = quantile(conc.n(:), 0.98);
imshow(conc.n * nscale, [0 maxn] * nscale, "colormap", ocean,
	"xdata", conc.xpos, "ydata", conc.ypos);
title("Number density of selenium atoms");
axis on;
colorbar;
