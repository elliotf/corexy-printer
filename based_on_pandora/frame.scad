include <./main.scad>;

module frame_assembly() {
  for(z=[bottom_pos_z+extrusion_side/2,top_pos_z-extrusion_side/2]) {
  //for(z=[bottom_pos_z+extrusion_side/2]) {
    translate([0,0,z]) {
      for(x=[left,right]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([90,0,0]) {
            % extrusion_l(extrusion_main_length);
          }
        }
      }
      for(y=[front,rear]) {
        translate([0,y*extrusion_vertical_spacing_y/2,0]) {
          rotate([0,90,0]) {
            % extrusion_l(extrusion_main_length);
          }
        }
      }
    }
  }

  hole_diam = extrusion_center_hole(extrusion_vertical_type) - 0.5;

  translate([rear_z_offset_x,extrusion_vertical_spacing_y/2-extrusion_side,bottom_pos_z+extrusion_main_length/2]) {
    % difference() {
      extrusion(extrusion_main_type,extrusion_main_length);
      translate([0,0,-extrusion_main_length/2+extrusion_side/2]) {
        rotate([90,0,0]) {
          hole(hole_diam,extrusion_side,resolution);
        }
      }
    }
  }
  translate([0,rear_brace_pos_y,rear_brace_pos_z]) {
    rotate([0,90,0]) {
      % extrusion(extrusion_shortest_type,extrusion_shortest_length);
    }
  }


  for(x=[left,right]) {
    for(y=[front,rear]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        % difference() {
          extrusion(extrusion_vertical_type,extrusion_vertical_length);
          translate([0,0,-extrusion_vertical_pos_z+gantry_pos_z]) {
            rotate([90,0,0]) {
              hole(hole_diam,extrusion_side,resolution);
            }
          }
          for(z=[top,bottom],r=[0,90]) {
            translate([0,0,z*(extrusion_vertical_length/2-extrusion_side/2)]) {
              rotate([0,0,r]) {
                rotate([90,0,0]) {
                  hole(hole_diam,extrusion_side,resolution);
                }
              }
            }
          }
        }
      }
    }

    translate([x*extrusion_vertical_spacing_x/2,0,gantry_pos_z]) {
      rotate([90,0,0]) {
        % extrusion_l(extrusion_main_length);
      }
    }
  }

  mirror_plug = 1;

  //mirror([mirror_plug,0,0]) {
    translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      rear_foot(left);
    }
    translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      psu_foot();
    }
  //}

  if (0) {
    panel_thickness = 3;
    translate([0,0,-z_base_motor_mount_overall_height-panel_thickness/2-0.1]) {
      rounded_diam = 5;
      % difference() {
        rounded_cube(bottom_panel_side,bottom_panel_side,panel_thickness,rounded_diam);
        for(x=[left,right],y=[front,rear]) {
          translate([x*(bottom_panel_hole_spacing_x/2),y*(bottom_panel_hole_spacing_y/2),-z_base_motor_mount_overall_height]) {
            hole(m3_through_hole_diam,100,resolution);
          }
        }
      }
    }
  }

  for(x=[left,right]) {
    translate([x*extrusion_vertical_spacing_x/2,0,0]) {
      skirt_filler(x);
    }
  }
}

frame_assembly();
