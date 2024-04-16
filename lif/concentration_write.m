if (!exist("conc", "var"))
	concentration_main;
end

if (!isfolder("results"))
	mkdir("results");
end
save -binary results/concentration.bin conc
