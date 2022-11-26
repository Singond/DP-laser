function x = load_iccd(data, dark = "", power = "", acc)
	[dir, name, ext] = fileparts(data);
	if (isempty(dark))
		dark = fullfile(dir, [name "_dark" ext]);
	end
	if (isempty(power))
		power = fullfile(dir, [name ".txt"]);
	end

	[x.img, x.imgm] = read_princeton_spe(data);
	x.acc = x.imgm.accum;
	x.readout = x.imgm.readouttime;

	if (isfile(dark))
		[x.dark, x.darkm] = read_princeton_spe(dark);
	else
		x.dark = [];
		x.darkm = [];
		warning("load_data: No dark image for %s", name);
	endif

	if (isfile(power))
		x.pwrdata = read_starlab(power);
	else
		x.pwrdata = [];
		warning("load_data: No power data for %s", name);
	endif
end
