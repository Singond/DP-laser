OCTAVE := octave --norc

presentation_figs := flame.png lif-example.png
presentation_figs += lifetime-lg.tex lifetime-regions.png
presentation_figs += timeev-5.0.png timeev-5.5.png timeev-6.0.png
presentation_figs += timeev-7.0.png timeev-10.0.png timeev-12.0.png
presentation_figs += vertical-center.tex vertical-edgel.tex

presentation_resources: ${presentation_figs:%=results/%}

results/concentration-vertical-centre.tex: concentration_vertical_export.m
	$(OCTAVE) --norc $<

results/flame.png results/lif-example.png: example_export.m
	octave --norc $<

results/lifetime.tex results/lifetime-lg.tex: \
lifetime_regions_export_fits.m lifetime_main.m
	octave --norc $<

results/lifetime-x-time.tex: lifetime_x_export.m results/lifetime.bin
	$(OCTAVE) --norc $<

results/lifetime-regions.png: \
lifetime_regions_export_img.m lifetime_regions.m
	octave --norc $<

results/liflines.tsv: liflines_export.m liflines_load.m concentration_main.m
	$(OCTAVE) $<

results/location.tex: location_export.m location_load.m
	$(OCTAVE) $<

results/saturation-full-example-index.tex: saturation_base_export.m
	octave --norc $<

results/saturation-full-params.tex results/saturation-full-paramsfits.tex \
results/saturation-full-profile.tex: \
saturation_full_export.m
	octave --norc $<

results/specoverlap.tex: specoverlap_export.m specoverlap_main.m
	$(OCTAVE) $<

results/timeev-%.png: timeev_export_png.m lifetime_main.m
	octave --norc $<

results/vertical-%.tex: vertical_regions_export.m vertical.m
	octave --norc $<

results/excitprof-filter.tex results/excitprof-nofilter.tex \
results/excitprof-fit.tex: \
wavelen_export.m
	octave --norc $<
