function x = frametimes(x, ftrig = 1, delay = 0)
	## Calculate mean laser energy for each camera frame.
	## Assume 'delay' second delay between starting power measurement
	## and camera capture.
	x.imgt = frametimes_princeton_spe(x.imgm, 1/ftrig);
	x.imgt += delay;

	x.E = [];
	for k = 1:length(x.pwrdata)
		pwrdata = x.pwrdata{k};
		x.E(:,k) = align_energy(pwrdata(:,1), pwrdata(:,2), x.imgt);
	endfor
end
