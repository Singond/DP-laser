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
endfor

figure(fig++);
clf;
hold on;
plot(caliper.dd, caliper.dpx, "d");
plot(caliper.dd, polyval(caliper.dfit, caliper.dd));
hold off;
xlabel("slit width [mm]");
ylabel("slit width [px]");
