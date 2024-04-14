pkg load optim;
addpath octave;

saturation_overall;
saturation_full_load;

X = saturation;
saturation = struct;
k = 1;
for x = X
	printf("Recalculating alpha in '%s'...\n", x.name);

	x.beta = saturationt.fite.b * 1e2;
	x.fita.a = dimfun(@ols, 3, x.lifsm, lif_planar_model_exp(x.Ly, [1 x.beta]));
	x.fita.f = @(yi,xi,Ly) lif_planar_model_exp(Ly, [x.fita.a(yi,xi,:) x.beta]);
	x.alpha = x.fita.a;

	saturation(k++) = x;
end
