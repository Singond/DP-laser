presentation_figs := lifetime-lg.tex lifetime-regions.png

presentation_resources: ${presentation_figs:%=results/%}

results/lifetime.tex results/lifetime-lg.tex: lifetime_export.m lifetime.m
	octave --norc $<

results/lifetime-regions.png: lifetime_regions_export.m lifetime.m
	octave --norc $<
