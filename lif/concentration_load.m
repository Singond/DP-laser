if (!exist("conc", "var"))
	if (isfile("results/concentration.bin"))
		load results/concentration.bin
		if (isolderthan("results/concentration.bin", "concentration_main.m"))
			warning("loading concentration data from file older than script");
		end
	else
		concentration_main;
	end
end
