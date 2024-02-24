pkg load singon-plasma;
addpath octave;

if (!exist("lifetime", "var"))
	if (isfile("results/lifetime.dat"))
		load results/lifetime.dat
	else
		lifetime_full;
	end
end
x = lifetime;

fig_inx = figure("name", "Time evolution along x");
surf(x.xpos, x.t, squeeze(x.inx)');
title("Time evolution of intensity summed along y");
set(gca, "ydir", "reverse");
xlabel("position x [px]");
ylabel("time t[ns]");
zlabel("intensity I_x [a.u.]");
view(-75, 20);

fig_taux = figure("name", "Lifetime along x");
errorbar(x.xpos, x.taux, x.tausigx, "d");
xlim([min(x.xpos) max(x.xpos)]);
ylim([0 2*quantile(x.taux, 0.99)]);
