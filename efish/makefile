JULIA := julia

results/%.tex: export.jl
	$(JULIA) $<

results/energy-%.tex: energy_export.jl energy.jl
	$(JULIA) $<

results/overview-%.tex: overview_export.jl
	$(JULIA) $<

results/pulse-compare.tex: pulse_compare_export.jl calibration.jl
	$(JULIA) $<
