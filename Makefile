all: m10 m8 m6

m6:
	openscad -m make -o stl/m6_gantry.stl stl/m6_gantry.scad

m8:
	openscad -m make -o stl/m8_gantry.stl stl/m8_gantry.scad

m10:
	openscad -m make -o stl/m10_gantry.stl stl/m10_gantry.scad
