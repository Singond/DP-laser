if (!exist("vertical", "var") || !isfield(saturation, "ins"))
	vertical_full;
end

x = vertical(1);

iscale = 1;

figure();
maxi = quantile(x.ins(:), 0.999);
imshow(x.ins * iscale, [0 maxi] * iscale, "colormap", viridis,
	"xdata", x.xmm, "ydata", x.ys);
set(gca, "ydir", "normal");
title("LIF signal over whole flame");
xlabel("position x [mm]");
ylabel("position y [mm]");
axis on;
grid off;
colorbar;
