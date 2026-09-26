include <./main.scad>;

dist_to_bottom = z_base_motor_mount_overall_height;
//dist_from_top_to_gantry = top_pos_z - gantry_pos_z - extrusion_side;
dist_from_bottom_to_gantry = gantry_pos_z - extrusion_side*1.5;
dist_between_vertical_brace_and_side = extrusion_vertical_spacing_x/2 + rear_z_offset_x - extrusion_side;

//echo("dist_from_top_to_gantry: ", dist_from_top_to_gantry);
echo("dist_from_bottom_to_gantry: ", dist_from_bottom_to_gantry);
echo("dist_between_vertical_brace_and_side: ", dist_between_vertical_brace_and_side);

module rear_vertical_beam_spacer() {
  module body() {
    rounded_cube(dist_between_vertical_brace_and_side,10,10,2);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module horizontal_beam_spacer() {
  echo("dist_from_bottom_to_gantry: ", dist_from_bottom_to_gantry);
  module body() {
    rounded_cube(dist_from_bottom_to_gantry,10,10,2);
    //cube([10,10,dist_from_bottom_to_gantry],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module tool_assembly() {
  translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2+extrusion_side,0]) {
    translate([0,0,extrusion_side + dist_from_bottom_to_gantry/2]) {
      rotate([0,90,0]) {
        horizontal_beam_spacer();
      }
    }
  }

  translate([-extrusion_vertical_spacing_x/2 + extrusion_side/2 + dist_between_vertical_brace_and_side/2,extrusion_vertical_spacing_y/2 - extrusion_side, bottom_pos_z]) {
    translate([0,0,0]) {
      rotate([0,0,0]) {
        rear_vertical_beam_spacer();
      }
    }
  }
}
