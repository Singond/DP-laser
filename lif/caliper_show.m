co = get(gca, "colororder");

fig = 1;
for x = caliper.X
	figure(fig++);
	clf;
	hold on;
	for k = 1:size(x.in, 2)
		plot(x.in(:,k), "color", co(k,:));
		plot(x.dbounds(:,k), interp1(x.in(:,k), x.dbounds(:,k)),
			"d", "color", co(k,:));
	endfor
	hold off;
	title(sprintf("Image intensity, width %.0f mm", x.d));
	xlabel("position [px]");
	ylabel("intensity [a.u.]");
endfor

figure(fig++);
clf;
hold on;
k = 1;
hax = [];
leg = cell;
for x = caliper.X
	h = plot(x.in, "color", co(k,:));
	for c = 1:columns(x.in)
		plot(x.dbounds(:,c), interp1(x.in(:,c), x.dbounds(:,c)),
			"d", "color", co(k,:));
	end
##	idx = linspace(70, 130, 1000);
##	for c = 1:x.N
##		plot(idx, x.infit{c}(idx), "--", "color", co(k,:));
##	end
	hax(k) = h(1);
	leg(k) = sprintf("%.0f mm", x.d);
	k++;
endfor
hold off;
title("Image intensity, all widths");
xlabel("position [px]");
ylabel("intensity [a.u.]");
legend(hax, leg);

figure(fig++);
clf;
hold on;
k = 1;
hax = [];
leg = cell;
for x = caliper.X
	h = plot(real(log(x.in)), "color", co(k,:));
##	idx = linspace(70, 130, 1000);
##	for c = 1:x.N
##		plot(idx, log(x.infit{c}(idx)), "--", "color", co(k,:));
##	end
	hax(k) = h(1);
	leg(k) = sprintf("%.0f mm", x.d);
	k++;
endfor
hold off;
title("Image intensity (logarithmic), all widths");
xlabel("position [px]");
ylabel("log intensity [a.u.]");
legend(hax, leg);

figure(fig++);
clf;
hold on;
plot(caliper.dd, caliper.dpx, "d", "displayname", "data");
plot(caliper.dd, polyval(caliper.dfit1, caliper.dd),
	"displayname", "through zero");
plot(caliper.dd, polyval(caliper.dfit2, caliper.dd),
	"displayname", "with y-intercept");
hold off;
title("Image scale calibration");
xlabel("slit width [mm]");
ylabel("slit width [px]");
legend("show");
legend("location", "northwest");
