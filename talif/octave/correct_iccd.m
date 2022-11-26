function x = correct_iccd(x)
	## TODO: Eliminate outliers

	## Subtract dark frame
	x.dark = mean(x.dark, 3);
	x.img -= x.dark;
	## Clip negative values
	x.img(x.img < 0) = 0;

	## Calculate mean laser energy for each camera frame.
	## Assume 0.1 second delay between starting power measurement
	## and camera capture.
	x.imgt = frametimes_princeton_spe(x.imgm, 1/50);
	x.imgt += 0.1;
	if (!isempty(x.pwrdata))
		x.E = align_energy(x.pwrdata(:,1), x.pwrdata(:,2), x.imgt);
	else
		x.E = [];
	endif
end
