tex_args := --pdflua --auxdir=tmp/

all: thesis.pdf presentation-efish.pdf presentation-lif.pdf

img/%.tex img/%.pdf: img/%.asy
	cd img && asy $*

img/%.tex img/%.pdf: img/%.gp
	cd img && gnuplot -d $*.gp

thesis.pdf: ../efish/results/overview-full.tex
thesis.pdf: ../efish/results/overview-period.tex
thesis.pdf: ../efish/results/pulse-compare.tex
thesis.pdf: ../efish/results/singleshot.tex
thesis.pdf: ../efish/results/singleshots-compare.tex
thesis.pdf: ../lif/results/concentration-vertical-centre.tex
thesis.pdf: ../lif/results/excitprof-nofilter.tex
thesis.pdf: ../lif/results/lifetime-x-time.tex
thesis.pdf: ../lif/results/liflines.tsv
thesis.pdf: ../lif/results/location.tex
thesis.pdf: ../lif/results/saturation-full-example-index.tex
thesis.pdf: ../lif/results/specoverlap.tex
thesis.pdf: img/cameraeff.pdf
thesis.pdf: img/camerafilter.pdf
thesis.pdf: img/lif-generator.pdf
thesis.pdf: img/lif-setup-general.pdf
thesis.pdf: img/lif-setup-se.pdf

thesis.pdf: thesis.tex frontmatter.tex efish.tex lif.tex references.bib
	latexmk ${tex_args} thesis && touch $@

presentation%.pdf: presentation%.tex
	latexmk ${tex_args} presentation$* && touch $@

presentation-lif.pdf: build/lif.timestamp

build/lif.timestamp:
	cd ../lif && $(MAKE) presentation_resources
	touch $@

../efish/%:
	cd ../efish && $(MAKE) $*

../lif/%:
	cd ../lif && $(MAKE) $*

clean:
	ls thesis.* presentation* | grep -v '\.tex$$' | xargs rm
