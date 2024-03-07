saturation_base;

X = saturation;

for k = 1:numel(X)
	X(k).in = X(k).img ./ X(k).acc;
	X(k).xpos = 1:size(X(k).img, 2);
	X(k).ypos = (1:size(X(k).img, 1))';
end

saturation = X;
