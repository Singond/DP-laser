function x = img_intensity(x)
	x.inraw = squeeze(sum(sum(x.img, 1), 2));
	x.in = x.inraw ./ (x.acc);
end
