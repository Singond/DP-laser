presentation_figs := flame.png lif-example.png
presentation_figs += lifetime-lg.tex lifetime-regions.png

presentation_resources: ${presentation_figs:%=results/%}

results/lifetime-lg.tex results/lifetime-regions.png: example_export.m
	octave --norc $<

results/lifetime.tex results/lifetime-lg.tex: lifetime_export.m lifetime_main.m
	octave --norc $<

results/lifetime-regions.png: lifetime_regions_export.m lifetime_main.m
	octave --norc $<
