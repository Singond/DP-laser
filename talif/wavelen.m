pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

d1 = load_iccd("data-2022-08-04/wavelen-1.SPE", "nodark");
d2 = load_iccd("data-2022-08-04/wavelen-2.SPE", "nodark");
