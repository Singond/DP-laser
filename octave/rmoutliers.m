function A = rmoutliers(A, factor=0.05, windowsize=[3 3])
	pkg load statistics;
	o = isoutlier(A(:), "grubbs", "ThresholdFactor", factor);
	o = reshape(o, size(A));
	Aclip = A;
	Aclip(o) = 0;
	if (isscalar(windowsize))
		windowsize = [windowsize windowsize];
	end
	window = ones(windowsize);
	window(ceil(end/2),ceil(end/2)) = 0;
	window = window ./ sum(window(:));
	Amean = conv2(Aclip, window, "same");
	A(o) = Amean(o);
end
