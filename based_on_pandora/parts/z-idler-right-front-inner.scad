include <../main.scad>;

mirror([0,0,0]) {
  rotate([0,-90,0]) {
    translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,-gantry_pos_z]) {
      z_idler_front_brace_inner(true);
    }
  }
}
