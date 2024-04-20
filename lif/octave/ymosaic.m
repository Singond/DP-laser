function M = ymosaic(y, images, ypos, weights=[])
	assert(numel(images) == numel(ypos));
	if (!isempty(weights) && !iscell(weights))
		weights = repmat({weights}, size(images));
	end

	miny = cellfun(@min, ypos);
	maxy = cellfun(@max, ypos);

	M = zeros(numel(y), size(images{1}, 2));
	if (!isempty(weights))
		W = zeros(numel(y), size(weights{1}, 2));
	end
	for k = 1:numel(images)
		if (!isempty(weights))
			w = interp1(ypos{k}, weights{k}, y, 0);
			W += w;
		else
			w = 1;
		end
		M += interp1(ypos{k}, images{k}, y, 0) .* w;
	end
	if (!isempty(weights))
		M = M ./ W;
	else
		M = M ./ k;
	end
end
