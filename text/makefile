tex_args := --pdflua --auxdir=tmp/

all: thesis.pdf presentation-efish.pdf presentation-lif.pdf

img/%.tex img/%.pdf: img/%.asy
	cd img && asy $*

thesis.pdf: ../lif/results/excitprof-nofilter.tex
thesis.pdf: ../lif/results/saturation-full-example-index.tex

thesis.pdf: thesis.tex frontmatter.tex efish.tex lif.tex references.bib
	latexmk ${tex_args} thesis && touch $@

presentation%.pdf: presentation%.tex
	latexmk ${tex_args} presentation$* && touch $@

presentation-lif.pdf: build/lif.timestamp

build/lif.timestamp:
	cd ../lif && $(MAKE) presentation_resources
	touch $@

../lif/%:
	cd ../lif && $(MAKE) $*

clean:
	ls thesis.* presentation* | grep -v '\.tex$$' | xargs rm
