tex_args := --pdflua --auxdir=tmp/

all: thesis.pdf presentation-efish.pdf presentation-lif.pdf

thesis.pdf: thesis.tex frontmatter.tex
	latexmk ${tex_args} thesis && touch $@

presentation%.pdf: presentation%.tex
	latexmk ${tex_args} presentation$* && touch $@

clean:
	ls thesis.* presentation* | grep -v '\.tex$$' | xargs rm
