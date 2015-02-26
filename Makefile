hub_diameters = 22.6 25.5
fanblades = $(foreach hub_d, $(hub_diameters), fan-blades-$(hub_d).stl fan-blades-shrouded-$(hub_d).stl fan-blades-winglets-$(hub_d).stl)

all: $(fanblades)
clean:
	rm -f $(fanblades)

fan-blades-%.stl: fan-blades.scad
	openscad -Dhub_d=$* -Dshroud=false -Dwinglets=false -o $@ $<

fan-blades-shrouded-%.stl: fan-blades.scad
	openscad -Dhub_d=$* -Dshroud=true -Dwinglets=false -o $@ $<

fan-blades-winglets-%.stl: fan-blades.scad
	openscad -Dhub_d=$* -Dshroud=false -Dwinglets=true -o $@ $<
