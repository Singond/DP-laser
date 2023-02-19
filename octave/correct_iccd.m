function x = correct_iccd(x)
	## TODO: Eliminate outliers

	## Subtract dark frame
	x.dark = mean(x.dark, 3);
	x.img -= x.dark;
	## Clip negative values
	x.img(x.img < 0) = 0;
end
