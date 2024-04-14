if (!exist("saturation", "var") || !isfield(saturation, "lifsm"))
	if (isfile("results/saturation.bin"))
		load results/saturation.bin
		if (isolderthan("results/saturation.bin", "saturation_full.m"))
			warning("loading saturation data from file older than script");
		end
	else
		saturation_full;
	end
end
