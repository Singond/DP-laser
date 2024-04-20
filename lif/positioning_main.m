pkg load singon-ext;

if (!exist("location", "var") && isfield(location, "pxpermm"))
	caliper_main;
end

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

x.xcenter = interp1(1:length(x.xpos), x.xpos, mean(x.minidx(:)));
printf("x center position:       %f px\n", x.xcenter);

## The center of the laser beam is about 2.5 mm above the atomizer
## in the first image (where h = 0).
## Shift y so that 0 is at the top of the atomizer.
laserycenter = 78;     # Maximum signal y position
x.ycenter = laserycenter + 2.5 * location.pxpermm;
printf("y center position:       %f px\n", x.ycenter);

positioning = x;
positioning.center = x.xcenter;
location.xcenter = positioning.xcenter;
location.ycenter = positioning.ycenter;
