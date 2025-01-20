include <../main.scad>;

mirror([0,0,0]) {
  rotate([0,-90,0]) {
    translate([0,0,0]) {
      z_carriage_bed_anchor_rear(true,2);
    }
  }
}
