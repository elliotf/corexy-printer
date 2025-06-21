include <../main.scad>;

mirror([0,0,0]) {
  rotate([90,0,0]) {
    translate([0,0,0]) {
      rear_z_chain_fixed_anchor();
    }
  }
}
