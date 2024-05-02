addpath ../octave;

if (!exist("lifetime", "var") || !isfield(lifetime, "taux"))
	if (isfile("results/lifetime.bin"))
		load results/lifetime.bin
		if (isolderthan("results/lifetime.bin", "lifetime_x.m"))
			warning("loading lifetime data from file older than script");
		end
	else
		lifetime_x;
	end
end
