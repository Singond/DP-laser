pkg load report;

if (!exist("R", "var") || !exist("Rt", "var"))
	rayleigh;
end

gp = gnuplotter;
gp.load("../style.gp");
gp.load("../style-cairo.gp");
for r = R
	gp.plot(r.ypos, r.iny, sprintf('w l t "L = %.3g \\muJ"', r.Em*1e6));
##	gp.plot(r.ypos, r.iny, sprintf('w l t "L""', r.Em*1e6));
end
gp.title("Beam vertical profile");
gp.xlabel("vertical position y [px]");
gp.ylabel("intensity I [a.u.]");
gp.export("results/rayleigh-profile.tex", "cairolatex", "size 10cm,8cm");
clear gp;
