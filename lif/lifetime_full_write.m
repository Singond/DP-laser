if (!exist("lifetime", "var"))
	lifetime_full;
end

if (!isfolder("results"))
	mkdir("results");
end
dlmwrite("results/lifetime.csv", x.tau);
