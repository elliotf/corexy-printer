include <../z_axis.scad>;

mirror([0,0,0]) {
  rotate([-90,0,0]) {
    translate([0,-rear_brace_pos_y,-extrusion_main_length]) {
      rear_vertical_center_brace_mount(true);
    }
  }
}
