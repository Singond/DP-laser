concentration_load;

nscale = 1;

figure("name", "Density");
maxn = quantile([conc.nma conc.nmw](:), 0.995);
imshow(conc.nma * nscale, [0 maxn] * nscale, "colormap", ocean,
	"xdata", conc.xpos, "ydata", conc.ypos);
title(sprintf(...
	"Number density of selenium atoms\n(mean of %d images)",...
	length(conc.E)));
axis on;
colorbar;

figure("name", "Density 2");
imshow(conc.nmw * nscale, [0 maxn] * nscale, "colormap", ocean,
	"xdata", conc.xpos, "ydata", conc.ypos);
title(sprintf(...
	"Number density of selenium atoms\n(weighted mean of %d images)",...
	length(conc.E)));
axis on;
colorbar;

figure("name", "Uncertainty");
imshow(conc.n_std * nscale, [], "colormap", ocean,
	"xdata", conc.xpos, "ydata", conc.ypos);
title("Number density of selenium atoms\n(standard deviation)");
axis on;
colorbar;
