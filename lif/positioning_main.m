x = load_iccd("data-2023-01-20/stred1.SPE", "nodark", "nopower");
x = crop_iccd(x, [65 93], [50 150]);
x.inx = mean(x.img, 1);

function r = findmin(x)
	[pk, loc] = findpeaksp(-x, "Sort", "prominence", "NPeaks", 1);
	r = [-pk loc];
end

r = dimfun(@findmin, 2, x.inx);
x.minval = r(:,1,:);
x.minidx = r(:,2,:);

x.center = interp1(1:length(x.xpos), x.xpos, mean(x.minidx(:)));
printf("center position:       %f px\n", x.center);

positioning = x;
