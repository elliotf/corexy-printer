include <../main.scad>;

mirror([1,0,0]) {
  rotate([0,180,0]) {
    translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,-gantry_pos_z]) {
      z_idler_front_brace_corner(true);
    }
  }
}
