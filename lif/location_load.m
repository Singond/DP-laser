addpath octave;

if (!exist("location", "var"))
	if (isfile("results/location.txt"))
		load results/location.txt
		if (isolderthan("results/location.txt", "positioning_main.m")
			|| isolderthan("results/location.txt", "caliper_main.m"))
			warning("loading location data from file older than script");
		end
	else
		caliper_main;
		positioning_main;
	end
end
