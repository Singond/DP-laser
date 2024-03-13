saturation_base;

X = saturation;

saturation = struct;
k = 1;
for x = X
	## Crop to area of interest
	x.ypos = (63:95)';  # rows
	x.xpos = 50:150;    # columns
	x = crop_iccd(x, [x.ypos(1) x.ypos(end)], [x.xpos(1) x.xpos(end)]);

	## Normalize LIF intensity
	x.lif = x.img ./ x.acc;

	## Laser intensity. Called E in older code, but L is less ambiguous.
	x.Ly = x.E ./ numel(x.ypos);

	p = polyfitm(reshape(x.Ly, 1, 1, []), x.lif, logical([1 1 0]), 3);
	x.fitl.a = p(:,:,2);
	x.fitl.b = -p(:,:,1) * (3 / 2) ./ x.fitl.a;
	x.fitl.f = @(yidx,xidx,Ly) polyval(p(yidx,xidx,:)(:), Ly);
	saturation(k++) = x;
end

