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

module drill_and_spacing_guide() {
  tight_tolerance = 0.1;
  wall_thickness = 3;
  wall_height = 1.4;
  low_wall_height = 1;
  bottom_thickness = 3;
  extrusion_spacing = dist_from_bottom_to_gantry + extrusion_side;
  narrow_width = 10;
  overall_length = extrusion_spacing+extrusion_side;
  overall_width = extrusion_side+2*(tolerance+wall_thickness);
  guide_length = (dist_from_bottom_to_gantry - extrusion_side)/2;

  echo("dist_from_bottom_to_gantry: ", dist_from_bottom_to_gantry);
  echo("extrusion_spacing: ", extrusion_spacing);
  echo("overall_length: ", overall_length);

  module body() {
    translate([0,0,-extrusion_side/2]) {
      translate([0,0,-bottom_thickness/2]) {
        hull() {
          bevel_height = 0.6;
          translate([0,0,bevel_height/2]) {
            rounded_cube(overall_length,narrow_width,bottom_thickness-bevel_height,3);
            rounded_cube(dist_from_bottom_to_gantry,overall_width,bottom_thickness-bevel_height,3);
          }
          rounded_cube(overall_length-bevel_height*2,narrow_width-bevel_height*2,bottom_thickness,3-bevel_height*2);
          rounded_cube(dist_from_bottom_to_gantry-bevel_height*2,overall_width-bevel_height*2,bottom_thickness,3-bevel_height*2);
        }
      }

      for(x=[left,right]) {
        for(y=[front,rear]) {
          translate([x*(dist_from_bottom_to_gantry/2-guide_length/2),y*(overall_width/2-wall_thickness/2),0]) {
            rounded_cube(guide_length,wall_thickness,wall_height*2,wall_thickness);
          }
        }
      }
      translate([overall_length/2-wall_thickness/2,0,0]) {
        //rounded_cube(wall_thickness,narrow_width,low_wall_height*2,wall_thickness);
      }
    }
  }

  module holes() {
    for(x=[left,-0.5,0,0.5,right]) {
      translate([x*(extrusion_spacing/2),0,0]) {
        hole(3.2,extrusion_side*2,resolution);
      }
    }
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

module full_length_hole_guide() {
  module body() {
    rounded_cube(extrusion_vertical_length,10,10,2);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module tool_assembly() {
  translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
    translate([0,0,extrusion_side + dist_from_bottom_to_gantry/2]) {
      rotate([0,90,0]) {
        drill_and_spacing_guide();
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

  translate([-extrusion_vertical_spacing_x/2-extrusion_side,-extrusion_vertical_spacing_y/2,0]) {
    translate([0,0,extrusion_vertical_pos_z]) {
      rotate([0,90,0]) {
        //full_length_hole_guide();
      }
    }
  }
}
