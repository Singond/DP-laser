tex_args := --pdflua --auxdir=tmp/

all: thesis.pdf presentation-efish.pdf presentation-lif.pdf

%.tex %.pdf: %.asy
	asy $<

thesis.pdf: thesis.tex frontmatter.tex
	latexmk ${tex_args} thesis && touch $@

presentation%.pdf: presentation%.tex
	latexmk ${tex_args} presentation$* && touch $@

presentation-lif.pdf: build/lif.timestamp

build/lif.timestamp:
	cd ../lif && $(MAKE) presentation_resources
	touch $@

clean:
	ls thesis.* presentation* | grep -v '\.tex$$' | xargs rm
