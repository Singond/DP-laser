if (!exist("lifetime", "var"))
	lifetime_full;
end

if (!isfolder("results"))
	mkdir("results");
end
dlmwrite("results/lifetime.csv", lifetime.tau);
save -binary results/lifetime.bin lifetime
