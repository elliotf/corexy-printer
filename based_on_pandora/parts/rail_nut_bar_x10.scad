include <../main.scad>;

rail_config = printer_config[RAIL_CONFIGURATION][y];
rail_type = rail_config[1];
rail_length = rail_config[2];

echo("rail_screw(rail_type): ", rail_screw(rail_type));

mirror([0,0,0]) {
  rotate([0,0,0]) {
    half_rail_nut_bar(rail_type,rail_length,true);
  }

  translate([0,0,-extrusion_side/2]) {
    rotate([0,90,0]) {
      % extrusion(extrusion_main_type, rail_length/2);
    }
  }
}
