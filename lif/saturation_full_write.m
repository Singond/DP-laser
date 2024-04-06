if (!exist("saturation", "var") || !isfield(saturation, "lifsm"))
	saturation_full;
end

if (!isfolder("results"))
	mkdir("results");
end
disp("Writing results/saturation.bin...");
save -binary results/saturation.bin saturation
