concentration_load;

printf("Camera filter\n")
wl = conc.liflines.wl(1);
printf("glass 1 transmittance:  %f\n", conc.camerafilter(1).at_wavelen(wl));
printf("glass 2 transmittance:  %f\n", conc.camerafilter(2).at_wavelen(wl));
printf("total transmittance:    %f\n", conc.liflines.T(1));
printf("total absorbance:       %f\n", 1 - conc.liflines.T(1));

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
