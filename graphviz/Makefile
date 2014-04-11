# Makefile für grapviz

%.png: %.dot
	dot -Tpng $< > $@

%.svg: %.dot
	dot -Tsvg $< > $@


all: router-graph.svg router-graph.png
