function x = load_iccd(data, dark = "", power = "", acc)
	[dir, name, ext] = fileparts(data);
	if (isempty(dark))
		dark = fullfile(dir, [name "_dark" ext]);
	end
	if (isempty(power))
		power = fullfile(dir, [name ".txt"]);
	end

	[x.img, x.imgm] = read_princeton_spe(data);
	[x.dark, x.darkm] = read_princeton_spe(dark);
	x.acc = x.imgm.accum;
	x.readout = x.imgm.readouttime;
	if (isfile(power))
		x.pwrdata = read_starlab(power);
	else
		x.pwrdata = [];
		warning("load_data: No power data for %s", name);
	endif
end
