all: fan-blades.stl

%.stl: %.scad
	openscad -o $@ $<
