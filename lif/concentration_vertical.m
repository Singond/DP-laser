pkg load singon-plasma;
addpath ../octave;

location_load;
rayleigh;
vertical_full;
concentration_load;

## Rescale intensity to match concentration calculated from other dataset.
## Extract reference area from concentration results:
##m = 70 <= conc.ypos & conc.ypos <= 90 & 90 <= conc.xpos & conc.xpos <= 110;
cref_n = conc.nm(15:30, 43:63);
## Extract corresponding area from this dataset
## (it seems to be shifted in the horizontal direction):
##v = vertical(1);
##m = 70 <= v.ypos & v.ypos <= 90 & 90 <= v.xpos & v.xpos <= 110;
cref_lif = vertical(1).inh(75:90,84:104,1);
## Use their ratio as calibration parameter.
cref_ratio = cref_n ./ cref_lif;
cref_scale = mean(cref_ratio(:));
cref_scale_std = std(cref_ratio(:));

for k = 1:numel(vertical)
	## Do the rescaling
	vertical(k).n = vertical(k).ins .* cref_scale;
end
