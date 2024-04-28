JULIA := julia

results/%.tex: export.jl
	$(JULIA) $<

results/overview-%.tex: overview_export.jl
	$(JULIA) $<
