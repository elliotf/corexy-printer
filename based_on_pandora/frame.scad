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

  hole_diam = extrusion_center_hole(extrusion_vertical_type) - 2;

  translate([rear_z_offset_x,rear_z_pos_y,rear_z_pos_z]) {
    % difference() {
      extrusion_l(extrusion_main_length);
      translate([0,0,-extrusion_main_length/2+extrusion_side/2]) {
        rotate([90,0,0]) {
          hole(hole_diam,extrusion_side,resolution);
        }
      }
    }
  }

  for(x=[left,right]) {
    for(y=[front,rear]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        % difference() {
          extrusion_l(extrusion_vertical_length);
          //extrusion(extrusion_vertical_type,extrusion_vertical_length);
          translate([0,0,-extrusion_vertical_pos_z+gantry_pos_z]) {
            rotate([90,0,0]) {
              //hole(hole_diam,extrusion_side,resolution);
            }
          }
          //for(z=[top,bottom],r=[0,90]) {
          vertical_holes = [
            [top*(extrusion_vertical_length/2-extrusion_side/2), [0,90]],
            [bottom*(extrusion_vertical_length/2-extrusion_side/2- z_base_motor_mount_overall_height), [0,90]],
            [-extrusion_vertical_pos_z+gantry_pos_z, [0]],
          ];
          for(hole=vertical_holes) {
            z = hole[0];
            translate([0,0,z]) {
              for(r=hole[1]) {
                rotate([0,0,r]) {
                  rotate([90,0,0]) {
                    hole(hole_diam,extrusion_side,resolution);
                  }
                }
              }
            }
          }
          echo("vertical_holes: ", vertical_holes);
          /*
          for(z=[top],r=[0,90]) {
            translate([0,0,z*(extrusion_vertical_length/2-extrusion_side/2)]) {
              rotate([0,0,r]) {
                rotate([90,0,0]) {
                  hole(hole_diam,extrusion_side,resolution);
                }
              }
            }
          }
          */

        }
      }
    }

    translate([x*extrusion_vertical_spacing_x/2,0,gantry_pos_z]) {
      rotate([90,0,0]) {
        % extrusion_l(extrusion_main_length);
      }
    }
  }

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
  /*
  plug_side = right;
  mirror([plug_side-1,0,0]) {
    translate([-extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      rear_foot(left);
    }
    translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      psu_foot();
    }
    for(x=[left,right]) {
      translate([x*extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,0]) {
        front_foot(x);
      }
    }
  }
  */

  echo("extrusion_vertical_spacing_x: ", extrusion_vertical_spacing_x);
}

frame_assembly();
