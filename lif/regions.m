region = struct;

region(1).shape = [95 72; 102 72; 102 88; 95 88];
region(1).name = "center";
region(2).shape = [73 72; 80 72; 80 88; 73 88];
region(2).name = "left edge";
region(3).shape = [117 72; 124 72; 124 88; 117 88];
region(3).name = "right edge";

function r = makemask(r)
	r.mask = maskpolygon([122 198], r.shape);
end

region = arrayfun(@makemask, region);
clear sz;
