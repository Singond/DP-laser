if (!exist("lifetime", "var"))
	if (isfile("results/lifetime.bin"))
		load results/lifetime.bin
		if (isolderthan("results/lifetime.bin", "lifetime_full.m"))
			warning("loading lifetime data from file older than script");
		end
	else
		lifetime_full;
	end
end
