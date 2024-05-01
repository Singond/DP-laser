pkg load singon-ext;
pkg load singon-plasma;
addpath ../octave;

wavelen1 = struct();
wavelen1(1) = load_iccd("data-2022-08-04/wavelen-1.SPE", "nodark");
wavelen1(2) = load_iccd("data-2022-08-04/wavelen-2.SPE", "nodark");
