include <../main.scad>;

mirror([0,0,0]) {
  rotate([0,90,0]) {
    translate([0,-rear_brace_pos_y,-rear_brace_pos_z]) {
      z_idler_top_idler(true);
    }
  }
}
