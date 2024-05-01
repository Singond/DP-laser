JULIA := julia

results/%.tex: export.jl
	$(JULIA) $<

results/calib-overview-%.tex: calib_overview_export.jl
	$(JULIA) $<

results/energy-%.tex: energy_export.jl energy.jl
	$(JULIA) $<

results/period-%.tex: period_export.jl main.jl
	$(JULIA) $<

results/period-overview-%.tex: period_overview_export.jl main.jl
	$(JULIA) $<

results/pulse-compare.tex: pulse_compare_export.jl calibration.jl
	$(JULIA) $<
