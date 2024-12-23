include <../main.scad>;

mirror([0,0,0]) {
  rotate([-90,0,0]) {
    translate([0,-rear_brace_pos_y,-rear_brace_pos_z]) {
      umbilical_wire_guard(true);
    }
  }
}
