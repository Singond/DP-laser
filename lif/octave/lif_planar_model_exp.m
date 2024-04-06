function F = lif_planar_model_exp(Ly, p)
	F = p(1) - (p(1)/p(2)) * log(1 + p(2) * Ly) ./ Ly;
end
