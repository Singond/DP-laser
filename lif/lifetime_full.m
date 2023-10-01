lifetime_base;

x = lifetime(2);
in = x.img ./ x.acc;
fits = fit_decay(x.t, in(60:70,:,:), "dim", 3, "from", 7e-9, "progress");
tau = cellfun(@(c) c.fite.tau, fits);
