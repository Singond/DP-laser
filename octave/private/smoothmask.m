function m = smoothmask(height, width, fun, smooth)
	if (smooth < 1)
		sx = sy = 0;
	else
		spread = linspace(-0.5, 0.5, smooth);
		[sx, sy] = meshgrid(spread, spread);
	end

	m = zeros(height, width);
	[xx, yy] = meshgrid(1:width, 1:height);
	for k = 1:numel(sx)
		m += fun(xx + sx(k), yy + sy(k));
	end
	m /= numel(sx);
end
