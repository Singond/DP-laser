pkg load report;
addpath octave;

saturation_overall;
liflines_load;
concentration_load;

v.lifconclifsat = saturationt.fite.b;
v.lifconcb = liflines.B13;
v.lifconckappa = conc.kappa;
v.lifconcdensair = conc.densair;
v.lifconcrayleighdxsect = conc.rayleigh_dxsect;

writelatexvars("results/concentration-vars.tex", v);
