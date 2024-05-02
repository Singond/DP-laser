if (!exist("lifetime", "var") || !isfield(lifetime, "taux"))
	lifetime_x;
end

if (!isfolder("results"))
	mkdir("results");
end
save -binary results/lifetime.bin lifetime
