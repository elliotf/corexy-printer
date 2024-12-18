include <./main.scad>;

module frame_assembly() {
  for(z=[bottom_pos_z+extrusion_side/2,top_pos_z-extrusion_side/2]) {
  //for(z=[bottom_pos_z+extrusion_side/2]) {
    translate([0,0,z]) {
      for(x=[left,right]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([90,0,0]) {
            % extrusion(extrusion_main_length);
          }
        }
      }
      for(y=[front,rear]) {
        translate([0,y*extrusion_vertical_spacing_y/2,0]) {
          rotate([0,90,0]) {
            % extrusion(extrusion_main_length);
          }
        }
      }
    }
  }
  translate([rear_z_offset_x,extrusion_vertical_spacing_y/2-extrusion_side,bottom_pos_z+extrusion_main_length/2]) {
    % extrusion(extrusion_main_length);
  }
  translate([0,rear_brace_pos_y,motor_xy_pos_z+extrusion_side/2+xy_motor_plate_thickness]) {
    rotate([0,90,0]) {
      % extrusion(extrusion_shortest_length);
    }
  }

  for(x=[left,right]) {
  //for(x=[right]) {
    for(y=[front,rear]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        % extrusion(extrusion_vertical_length);
      }
    }

    translate([0,0,0]) {
      translate([x*(extrusion_vertical_spacing_x/2),0,extrusion_side+extrusion_short_length/2]) {
        //% extrusion(extrusion_short_length);
      }
    }

    translate([x*extrusion_vertical_spacing_x/2,0,gantry_pos_z]) {
      rotate([90,0,0]) {
        % extrusion(extrusion_main_length);
      }
    }
  }
}
