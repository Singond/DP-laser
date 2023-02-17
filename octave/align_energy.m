function r = align_energy(t, E, edges)
	if (columns(edges) == 1)
		skips = false;
	elseif (columns(edges) == 2)
		edges = edges'(:);
		skips = true;
	else
		error("align_energy: EDGES must be a 1- or 2-column matrix");
	end

	[~, idx] = histc(t, edges);
	m = idx > 0;
	r = accumarray(idx(m), E(m), [], @mean);
	if (skips)
		r = r(1:2:end);
	end
end
