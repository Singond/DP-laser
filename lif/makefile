presentation_figs := flame.png lif-example.png
presentation_figs += lifetime-lg.tex lifetime-regions.png
presentation_figs += timeev-5.0.png timeev-5.5.png timeev-6.0.png
presentation_figs += timeev-7.0.png timeev-10.0.png timeev-12.0.png

presentation_resources: ${presentation_figs:%=results/%}

results/flame.png results/lif-example.png: example_export.m
	octave --norc $<

results/lifetime.tex results/lifetime-lg.tex: lifetime_export.m lifetime_main.m
	octave --norc $<

results/lifetime-regions.png: lifetime_regions_export.m lifetime_main.m
	octave --norc $<

results/timeev-%.png: timeev_export.m lifetime_main.m
	octave --norc $<
