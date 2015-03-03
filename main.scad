include <config.scad>;
include <positions.scad>;
include <boxcutter.scad>;
use <util.scad>;

module debug_lines() {
  color("red") % translate([20,0,0]) {
    cube([40,.5,.5],center=true);
  }
  color("green") % translate([0,20,0]) {
    cube([.5,40,.5],center=true);
  }
  color("blue") % translate([0,0,20]) {
    cube([.5,.5,40],center=true);
  }
}

module line_hole() {
  accurate_circle(3,resolution);
}

module zip_tie_hole(diam,width=zip_tie_width,thickness=zip_tie_thickness) {
  difference() {
    hole(diam+thickness*2,width,resolution);
    hole(diam,width+.1,resolution);
  }
}

module bevel_hole(diam,height,sides) {
  hull() {
    hole(diam+height*2,extrusion_height,sides);
    hole(diam,extrusion_height+height*2.2,sides);
  }
}

module line_bearing() {
  res = 64;

  module body() {
    for(side=[top,bottom]) {
      hull() {
        translate([0,0,-side*(line_bearing_thickness/4)]) {
          hole(line_bearing_effective_diam,line_bearing_thickness/2,res);
        }
        translate([0,0,-side*(line_bearing_thickness/2-0.05)]) {
          hole(line_bearing_diam,0.1,res);
        }
      }
    }
  }

  module holes() {
    hole(line_bearing_inner, line_bearing_thickness+1,res);
  }

  difference() {
    body();
    holes();
  }
}

module line_bearing_bevel(sides=[top,bottom]) {
  difference() {
    for(side=sides) {
      translate([0,0,(line_bearing_thickness/2+line_bearing_washer_thickness)*side]) {
        hull() {
          hole(line_bearing_inner+1,line_bearing_washer_thickness*2,8);
          translate([0,0,line_bearing_washer_thickness*side]) {
            hole(line_bearing_inner+4,line_bearing_washer_thickness,8);
          }
        }
      }
    }

    hole(line_bearing_inner,line_bearing_thickness*3,8);
  }
}

module hotend() {
  module body() {
    height_groove_and_above = hotend_clamped_height;
    height_below_groove = hotend_len - height_groove_and_above;

    translate([0,0,-hotend_height_above_groove/2]) {
      hole(hotend_diam,hotend_height_above_groove,90);
    }
    translate([0,0,-hotend_height_above_groove-hotend_groove_height/2]) {
      hole(hotend_groove_diam,hotend_groove_height,90);
    }
    translate([0,0,-height_groove_and_above-height_below_groove/2]) {
      hole(hotend_diam,height_below_groove,90);
    }
  }

  module holes() {
    hole(filament_diam,hotend_len*3,8);
  }

  difference() {
    body();
    holes();
  }
}

module motor() {
  difference() {
    translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) cylinder(r=motor_shaft_diam/2,h=motor_shaft_len,center=true);
}

module motor_sheet_holes() {
  accurate_circle(z_motor_shoulder_diam,resolution);

  for(x=[left,right]) {
    for(y=[top,bottom]) {
      translate([z_motor_hole_spacing/2*x,z_motor_hole_spacing/2*y]) {
        accurate_circle(z_motor_screw_diam,resolution);
      }
    }
  }
}

module hotend_groove_mount_void() {
  hotend_clearance = 0.1;
  hotend_res = resolution;
  above_height = hotend_height_above_groove+hotend_clearance*2;
  for(side=[left,right]) {
    translate([0,(m3_nut_diam/2+filament_diam)*side,0]) {
      rotate([0,0,60+45]) {
        //# hole(m3_nut_diam,m3_nut_thickness*2+.5,6);
      }
    }
  }
  rotate([0,0,0]) {
    // hole(filament_diam+0.25,20,8);
  }
  rotate([0,0,90]) {
    translate([0,0,-hotend_clamped_height]) {
      hole(hotend_groove_diam+hotend_clearance,hotend_clamped_height*2,hotend_res);
      translate([0,-hotend_diam/2,0]) {
        cube([hotend_groove_diam,hotend_diam,hotend_clamped_height*2],center=true);
      }
    }

    translate([0,0,-above_height/2+hotend_clearance]) {
      hole(hotend_diam+hotend_clearance,above_height,hotend_res);
      translate([0,-hotend_diam/2,0]) {
        cube([hotend_diam,hotend_diam,above_height],center=true);
      }
    }

    // zip tie restraint
    translate([0,0,-above_height/2]) {
      zip_tie_hole(hotend_diam + wall_thickness*2.5);
    }

    translate([0,0,-hotend_clamped_height-10+hotend_clearance]) {
      hole(hotend_diam+hotend_clearance,20,hotend_res);
      translate([0,-hotend_diam/2,0]) {
        cube([hotend_diam,hotend_diam,20],center=true);
      }
    }
  }
}

module x_carriage() {
  body_side = rear;

  bearing_body_diam = x_bearing_diam+wall_thickness*3;
  bearing_body_diam = top_line_pos_y*2;

  body_depth  = top_line_pos_y - bottom_line_pos_y;
  body_height = x_rod_spacing;

  tuner_mount_width  = x_carriage_width;
  tuner_mount_depth  = tuner_shaft_screwed_diam+wall_thickness*3;
  tuner_mount_height = tuner_shaft_screwed_len;

  bottom_top_dist_z     = top_line_pos_z - bottom_line_pos_z;
  bottom_top_dist_y     = top_line_pos_y - bottom_line_pos_y;
  bottom_top_dist_angle = sqrt(pow(bottom_top_dist_z,2)+pow(bottom_top_dist_y,2));
  bottom_top_line_angle = atan2(bottom_top_dist_z,bottom_top_dist_y);

  line_hole_opening     = 1.1;

  tuner_rotate_z = -55;
  module position_tuner() {
    translate([tuner_pos_x,tuner_pos_y,top_line_pos_z]) {
      rotate([0,0,tuner_rotate_z]) {
        rotate([0,90,0]) {
          children();
        }
      }
    }
  }

  module body() {
    // bearing holders
    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(bearing_body_diam,x_carriage_width,resolution);
        }
      }
    }

    // body between bearing holders
    translate([0,bottom_line_pos_y+body_depth/2,0]) {
      cube([x_carriage_width,body_depth,body_height],center=true);
    }

    // tuner retainer body
    hull() {
      translate([0,tuner_pos_y,tuner_shoulder_pos_z-tuner_mount_height/2]) {
        for(y=[front]) {
          for(z=[top,bottom]) {
            translate([0,y*(tuner_mount_depth/2-rounded_diam/2),z*(tuner_mount_height/2-rounded_diam/2)]) {
              rotate([0,90,0]) {
                hole(rounded_diam,tuner_mount_width,resolution);
              }
            }
          }
        }
        for(y=[rear]) {
          for(z=[top,bottom]) {
            translate([0,y*(tuner_mount_depth/2-rounded_diam/2+wall_thickness*z),z*(tuner_mount_height/2-rounded_diam/2)]) {
              rotate([0,90,0]) {
                hole(rounded_diam,tuner_mount_width,resolution);
              }
            }
          }
        }
      }
    }

    rounded_diam = 5;
    // conntect top bearing to tuner mount
    hull() {
      translate([0,tuner_pos_y,tuner_shoulder_pos_z-tuner_mount_height/2]) {
        for(y=[front]) {
          for(z=[top,bottom]) {
            translate([0,y*(tuner_mount_depth/2-rounded_diam/2),z*(tuner_mount_height/2-rounded_diam/2)]) {
              rotate([0,90,0]) {
                hole(rounded_diam,tuner_mount_width,resolution);
              }
            }
          }
        }
      }

      translate([0,0,x_rod_spacing/2]) {
        rotate([0,90,0]) {
          hole(bearing_body_diam,x_carriage_width,resolution);
        }
      }
    }

    // hotend mount
    hotend_mount_width  = x_carriage_width/2 + hotend_diam/2 + wall_thickness*1.5;
    hotend_mount_depth  = tuner_pos_y - hotend_y;
    hotend_mount_height = hotend_clamped_height + 2;
    translate([-x_carriage_width/2+hotend_mount_width/2,tuner_pos_y-hotend_mount_depth/4,tuner_shoulder_pos_z-hotend_mount_height/2]) {
      cube([hotend_mount_width,hotend_mount_depth/2,hotend_mount_height],center=true);
    }
    hull() {
      translate([0,hotend_y,tuner_shoulder_pos_z-hotend_mount_height/2]) {
        translate([-x_carriage_width/2+hotend_mount_width/2,-hotend_y,0]) {
          cube([hotend_mount_width,4,hotend_mount_height],center=true);
        }
        translate([-x_carriage_width/4,-hotend_y/2,0]) {
          rotate([0,90,0]) {
            hole(hotend_mount_height,x_carriage_width/2,resolution);
          }
        }
        translate([0,0,2]) {
          hole(hotend_diam+wall_thickness*3,hotend_mount_height+4,resolution);
        }
        translate([0,0,hotend_mount_height/2+4]) {
          hole(hotend_diam,8,resolution);
        }
      }
    }
  }

  module holes() {
    // filament path
    translate([0,hotend_y,0]) {
      # hole(6.4,100,8);
    }

    // hotend mount
    hotend_groove_depth = (hotend_diam - hotend_groove_diam)/2;
    translate([0,hotend_y,tuner_shoulder_pos_z]) {
      rotate([0,0,-45]) {
        hotend_groove_mount_void();
      }

      translate([hotend_diam-hotend_groove_depth*1.5,-hotend_diam+hotend_groove_depth*1.5,-hotend_clamped_height]) {
        cube([hotend_diam*2,hotend_diam*2,hotend_clamped_height*2+hotend_clearance],center=true);
      }
    }

    tuner_hollow_nut_height = tuner_mount_height*.75;
    // tuner mounting
    for(side=[left,right]) {
      translate([tuner_pos_x*side,tuner_pos_y,0]) {
        // anchor screw
        rotate([0,0,tuner_rotate_z*side]) {
          translate([-tuner_body_diam/2*side,-tuner_body_diam/2,0]) {
            rotate([0,0,tuner_rotate_z*-side]) {
              hole(tuner_anchor_screw_hole_diam-0.2,100,8);
            }
          }
        }

        // main hole and screw hole
        translate([0,0,tuner_shoulder_pos_z]) {
          hole(tuner_shaft_screw_diam,tuner_mount_height*2+1,8);
          hole(tuner_shaft_screwed_diam,21,8);

          translate([0,0,-tuner_mount_height-tuner_hollow_nut_height/2]) {
            hole(tuner_nut_max_diam,tuner_hollow_nut_height,resolution);
          }
        }
      }
    }

    // reinforcements
    for(z=[1,3,5]) {
      for(x=[-6,0,6]) {
        translate([x,tuner_pos_y+tuner_mount_depth/2+1,tuner_shoulder_pos_z-3*z]) {
          cube([1,tuner_mount_depth+tuner_shaft_screwed_diam,1],center=true);
        }
      }
    }

    // line path
    translate([0,top_line_pos_y,top_line_pos_z]) {
      rotate([bottom_top_line_angle,0,0]) {
        rotate([0,90,0]) {
          hole(line_hole_opening,x_carriage_width+1,8);
        }
      }
    }
    translate([0,bottom_line_pos_y,bottom_line_pos_z]) {
      rotate([bottom_top_line_angle,0,0]) {
        rotate([0,90,0]) {
          hole(line_hole_opening,x_carriage_width+1,8);
        }
      }
    }
    front_to_back_line_path_diam = bottom_top_dist_angle-line_hole_opening;
    for(side=[left,right]) {
      translate([(x_carriage_width/2-front_to_back_line_path_diam/2-.5)*side,top_line_pos_y-bottom_top_dist_y/2,top_line_pos_z-bottom_top_dist_z/2]) {
        rotate([bottom_top_line_angle,0,0]) {
          difference() {
            translate([side*(bottom_top_dist_angle/2-2),2,0]) {
              cube([bottom_top_dist_angle/2+2,bottom_top_dist_angle+4,line_hole_opening],center=true);
            }
            hole(front_to_back_line_path_diam,line_hole_opening+1,resolution);
          }
        }
      }
    }

    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          // bearing hole
          hole(x_bearing_diam,x_carriage_width+1,resolution);
          // beveled opening
          for(end=[left,right]) {
            hull() {
              translate([0,0,(x_carriage_width/2)*end]) {
                hole(x_bearing_diam,3,resolution);
                translate([0,0,.5*end]) {
                  hole(x_bearing_diam+1,1,resolution);
                }
              }
            }
          }
        }

      }
    }

    // bearing front opening top
    translate([0,0,x_rod_spacing/2]) {
      for(r=[0]) {
        rotate([r,0,0]) {
          translate([extrusion_height,-bearing_body_diam/4-1,-bearing_body_diam/4-1]) {
            cube([x_carriage_width,bearing_body_diam/2+2,bearing_body_diam/2+2],center=true);
          }
        }
      }
    }

    // bearing opening bottom
    translate([0,0,-x_rod_spacing/2]) {
      for(r=[40,-30]) {
        rotate([r,0,0]) {
          translate([extrusion_height,-bearing_body_diam/4-1,-bearing_body_diam/4-1]) {
            cube([x_carriage_width,bearing_body_diam/2+2,bearing_body_diam/2+2],center=true);
          }
        }
      }
    }
  }
  translate([0,top_line_pos_y,top_line_pos_z]) {
    //color("green") % cube([x_carriage_width+60,0.8,0.8],center=true);
  }
  translate([0,bottom_line_pos_y,bottom_line_pos_z]) {
    //color("red") % cube([x_carriage_width+60,0.8,0.8],center=true);
  }

  for(side=[left,right]) {
    mirror([1+side,0,0]) {
      position_tuner() {
        % tuner();
      }
    }
  }

  difference() {
    body();
    holes();
  }

  % for(side=[top,bottom]) {
    translate([0,0,x_rod_spacing/2*side]) {
      rotate([0,90,0]) {
        cylinder(r=x_bearing_diam/2,h=x_bearing_len,center=true);
      }
    }
  }

  translate([0,hotend_y,hotend_z]) {
    % hotend();
  }
}

module y_carriage() {
  line_bearing_x              = (y_rod_x - y_carriage_line_bearing_x);
  line_bearing_opening_height = line_bearing_thickness*2+line_bearing_washer_thickness*3;
  rod_hole_diam               = x_rod_diam + rod_slop;
  x_rod_clamp_len             = y_carriage_width;

  module body() {
    // main body, hold x rods
    hull() {
      for(side=[top,bottom]) {
        translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            hole(y_rod_diam+rod_slop+min_material_thickness*4,x_rod_clamp_len,resolution);
          }
        }
      }
      intersection() {
        translate([y_bearing_diam/2,0,0]) {
          cube([y_bearing_diam,y_carriage_depth*2,y_bearing_diam*2],center=true);
        }
        rotate([90,0,0]) {
          hole(y_bearing_diam+min_material_thickness*8,y_carriage_depth,resolution);
        }
      }
      translate([x_rod_clamp_len/2,y_carriage_line_bearing_y,0]) {
        cube([x_rod_clamp_len,line_bearing_nut_diam+min_material_thickness*4,y_carriage_height],center=true);
      }
    }
  }

  module holes() {
    // x rods and clamps
    for(side=[top,bottom]) {
      translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(rod_hole_diam+rod_slop,x_rod_clamp_len+4,resolution);

          for(end=[left,right]) {
            translate([0,0,(x_rod_clamp_len/2+.5)*end]) {
              hull() {
                hole(rod_hole_diam,3,resolution);
                hole(rod_hole_diam+1,1,resolution);
              }
            }
          }
        }

        translate([-extrusion_height,20,0]) {
          cube([x_rod_clamp_len,40,2],center=true);
        }
      }
    }

    // zip tie to secure the carriage to the y rod bearing
    translate([0,-rod_hole_diam/2-zip_tie_width,0]) {
      rotate([90,0,0]) {
        zip_tie_hole(y_bearing_diam+min_material_thickness*2);
      }
    }

    // y rod bearing and clamp
    translate([0,0,0]) {
      rotate([90,0,0]) {
        hole(y_bearing_diam,y_bearing_len*2,resolution);
      }
    }

    // bearing/line-related holes
    translate([line_bearing_x-line_bearing_effective_diam/2-0.4,y_carriage_line_bearing_y,0]) {
      translate([0,0,to_front_line_z]) {
        rotate([90,0,0]) {
          hole(2,60,8);
        }
      }
      translate([0,0,return_line_z]) {
        rotate([90,0,0]) {
          hole(2,60,8);
        }
      }
    }
    translate([line_bearing_x,y_carriage_line_bearing_y,y_carriage_line_bearing_z]) {
      // bearing/clamp screw
      hole(line_bearing_inner+rod_slop,50,8);

      hull() {
        hole(line_bearing_diam + spacer*2,line_bearing_opening_height,resolution);
        // room for belt/filament
        translate([0,line_bearing_diam/2,0]) {
          cube([line_bearing_diam+spacer*2,line_bearing_diam+spacer*2,line_bearing_opening_height],center=true);
        }
        translate([line_bearing_diam/2,0,0]) {
          cube([line_bearing_diam+spacer*2,line_bearing_diam+spacer*2,line_bearing_opening_height],center=true);
        }
      }

      for (side=[top,bottom]) {
        translate([0,0,(line_bearing_thickness/2+line_bearing_washer_thickness/2)*side]) {
          % line_bearing();
        }
      }
    }
  }

  module bridges() {
    for(side=[top,bottom]) {
      translate([line_bearing_x,y_carriage_line_bearing_y,y_carriage_line_bearing_z+side*(line_bearing_washer_thickness/2+line_bearing_thickness/2)]) {
        line_bearing_bevel([side]);
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();

  translate([0,0,0]) {
    rotate([90,0,0]) {
      % cylinder(r=y_bearing_diam/2,h=y_bearing_len,center=true);
    }
  }
}

module handle() {
  module body() {
    hull() {
      translate([0,-handle_attachment_height/2,0]) {
        cube([handle_hole_width+handle_material_width*2,handle_attachment_height,sheet_thickness],center=true);
      }

      for(x=[left,right]) {
        translate([x*(handle_hole_width/2+handle_material_width/2-5),handle_hole_height+handle_material_width/2,0]) {
          hole(handle_material_width,sheet_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    hull() {
      for(x=[left,right]) {
        translate([x*(handle_hole_width/2-handle_material_width/2),handle_hole_height/2+top*(handle_hole_height/2-handle_material_width/2),0]) {
          hole(handle_material_width,sheet_thickness+1,resolution);
        }
        translate([x*(handle_hole_width/2-handle_material_width/2),handle_hole_height/2+bottom*(handle_hole_height/2-handle_material_width/2),0]) {
          hole(handle_material_width,sheet_thickness+1,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_sheet() {
  rounded_diam = bc_shoulder_width*2;

  module body() {
    width  = front_sheet_width + sheet_thickness*2 + bc_shoulder_width*2;
    height = sheet_height      + sheet_thickness + bc_shoulder_width;
    intersection() {
      box_side([front_sheet_width,sheet_height],[0,4,4,4]);
      translate([0,-sheet_thickness/2-bc_shoulder_width/2]) {
        hull() {
          for(x=[left,right]) {
            for(y=[top,bottom]) {
              translate([x*(width/2-rounded_diam/2),y*(height/2-rounded_diam/2),0]) {
                accurate_circle(rounded_diam,resolution);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    translate([0,-sheet_pos_z,0]) {
      translate([0,top_sheet_pos_z,0]) {
        box_holes_for_side(front_sheet_width,4);
      }

      for(side=[left,right]) {
        translate([y_rod_x*side,0,0]) {
          accurate_circle(y_rod_diam-laser_cut_kerf*2,64);
        }

        translate([xy_line_x*side,0,0]) {
          translate([0,mid_line_z,0]) {
            line_hole();
          }

          translate([0,to_front_line_z,0]) {
            line_hole();
          }
        }
      }
    }

    // rounded top opening
    for(side=[left,right]) {
      translate([side*(front_opening_width/2-sheet_thickness),sheet_height/2,0]) {
        difference() {
          square([rounded_diam,rounded_diam],center=true);
          translate([rounded_diam/2*side,-rounded_diam/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }
    }

    front_opening_width = main_opening_width - sheet_thickness*2;
    hull() {
      translate([0,sheet_height/2,0]) {
        for(side=[left,right]) {
          translate([side*(build_x/2-sheet_thickness-rounded_diam/2),-main_opening_height+rounded_diam/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
          translate([side*(front_opening_width/2-sheet_thickness-rounded_diam/2),-hotend_sheet_clearance+rounded_diam/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
        square([front_opening_width-sheet_thickness*2,2],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rear_sheet() {
  rounded_diam = bc_shoulder_width*2;

  module body() {
    width  = front_sheet_width + sheet_thickness*2 + bc_shoulder_width*2;
    height = sheet_height      + sheet_thickness + bc_shoulder_width;
    intersection() {
      box_side([front_sheet_width,sheet_height],[0,4,4,4]);
      translate([0,-sheet_thickness/2-bc_shoulder_width/2]) {
        hull() {
          for(x=[left,right]) {
            for(y=[top,bottom]) {
              translate([x*(width/2-rounded_diam/2),y*(height/2-rounded_diam/2),0]) {
                accurate_circle(rounded_diam,resolution);
              }
            }
          }
        }
      }
    }
  }

  z_belt_opening_width  = z_brace_pos_x*2-z_brace_body_width;
  z_belt_opening_height = z_brace_screw_dist_from_corner;
  z_belt_opening_pos_z  = bottom_sheet_pos_z + sheet_thickness/2 + z_belt_opening_height/2;

  module holes() {
    translate([0,-sheet_pos_z]) {
      translate([0,top_sheet_pos_z]) {
        box_holes_for_side(front_sheet_width,4);
      }
      for(side=[left,right]) {
        translate([y_rod_x*side,0,0]) {
          accurate_circle(y_rod_diam-laser_cut_kerf*2,64);
        }

        hull() {
          translate([xy_line_x*side,0]) {
            translate([0,top_line_z]) {
              line_hole();
            }

            translate([0,mid_line_z]) {
              line_hole();
            }
          }
        }

        translate([xy_motor_pos_x*side,xy_motor_pos_z,0]) {
          rotate([0,0,0]) {
            motor_sheet_holes();
          }
        }

        translate([z_brace_pos_x*side,top_sheet_pos_z-sheet_thickness/2-z_brace_screw_dist_from_corner]) {
          accurate_circle(3,resolution/2);
        }
        translate([z_brace_pos_x*side,bottom_sheet_pos_z+sheet_thickness/2+z_brace_screw_dist_from_corner]) {
          accurate_circle(3,resolution/2);
        }
        translate([0,bottom_sheet_pos_z+sheet_thickness/2]) {
          hull() {
            translate([0,z_pulley_sheet_dist_z]) {
              square([z_belt_opening_width,z_pulley_diam+belt_thickness*4+spacer*2],center=true);
            }
            translate([0,motor_side/2+z_line_bearing_diam/2,0]) {
              square([z_belt_opening_width,z_line_bearing_diam*1.1],center=true);
            }
          }
        }
      }
    }

    height_below_top_sheet = abs(-sheet_pos_z+top_sheet_pos_z + side_sheet_height/2);

    rounded_diam     = 10;
    main_hole_width  = front_sheet_width      - motor_side*2.5;
    main_hole_height = height_below_top_sheet - motor_side*2.5;

    hull() {
      translate([0,-side_sheet_height/2+height_below_top_sheet/2]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(main_hole_width/2-rounded_diam)*x,(main_hole_height/2-rounded_diam)*y]) {
              accurate_circle(rounded_diam,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module side_sheet() {
  bottom_material  = 30;
  hotend_clearance = -1*(hotend_z-hotend_len/2-top_of_sheet);

  opening_height = min((sheet_height - bottom_material),(sheet_height*.5));

  module body() {
    box_side([side_sheet_depth,side_sheet_height],[0,3,4,3]);
  }

  height_below_top_sheet = abs(-sheet_pos_z+top_sheet_pos_z + side_sheet_height/2);

  module holes() {
    translate([0,-sheet_pos_z+top_sheet_pos_z]) {
      box_holes_for_side(side_sheet_depth,4);
    }

    rounded_diam     = 10;
    main_hole_depth  = side_sheet_depth       - motor_side*2;
    main_hole_height = height_below_top_sheet - motor_side*2.5;

    hull() {
      translate([0,-side_sheet_height/2+height_below_top_sheet/2]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(main_hole_depth/2-rounded_diam)*x,(main_hole_height/2-rounded_diam)*y]) {
              accurate_circle(rounded_diam,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module top_sheet() {
  module body() {
    box_side([top_sheet_width,top_sheet_depth],[3,3,3,3]);
  }

  module holes() {
    hole_diam = sheet_thickness*2;
    front_y   = front*top_sheet_depth/2;

    front_opening_width = main_opening_width - sheet_thickness*2;

    hull() {
      for(x=[left,right]) {
        for(y=[front_y+hole_diam,front_y+main_opening_depth-hole_diam/2]) {
          translate([x*(main_opening_width/2-hole_diam/2),y]) {
            accurate_circle(hole_diam,resolution);
          }
        }
      }
      translate([0,front*(top_sheet_depth/2-sheet_thickness/2+0.05)]) {
        square([front_opening_width-hole_diam,sheet_thickness],center=true);
      }
    }
    translate([0,front*(top_sheet_depth/2)]) {
      square([front_opening_width-sheet_thickness*2,sheet_thickness*4],center=true);
    }

    for(side=[left,right]) {
      translate([z_brace_pos_x*side,top_sheet_depth/2-z_brace_screw_dist_from_corner]) {
        accurate_circle(3,resolution/2);
      }
      translate([z_rod_pos_x*side,z_rod_pos_y]) {
        accurate_circle(y_rod_diam-laser_cut_kerf*2,64);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module bottom_sheet() {
  width = side_sheet_pos_x*2 - sheet_thickness;
  depth = sheet_pos_y*2 - sheet_thickness;

  module body() {
    box_side([width,top_sheet_depth],[3,3,3,3]);
  }

  module holes() {
    for(side=[left,right]) {
      translate([z_rod_pos_x*side,z_rod_pos_y,0]) {
        accurate_circle(z_rod_diam-laser_cut_kerf*2,64);
      }
      translate([z_brace_pos_x*side,top_sheet_depth/2-z_brace_screw_dist_from_corner,0]) {
        accurate_circle(3,resolution/2);
      }
    }

    rounded_diam     = 10;
    main_hole_width = width            - motor_side*2.5;
    main_hole_depth  = top_sheet_depth - motor_side*2.5;

    hull() {
      for(x=[left,right]) {
        for(y=[front,rear]) {
          translate([(main_hole_width/2-rounded_diam)*x,(main_hole_depth/2-rounded_diam)*y,0]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_xy_endcap() {
  mount_thickness = 6;
  wall_thickness  = extrusion_width*4;

  line_x = xy_line_x-y_rod_x;

  bearing_y = front*(mount_thickness+line_bearing_nut_diam/2+spacer);
  bearing_z = to_front_line_z-line_bearing_effective_diam/2;

  module bearing_base() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([(bearing_body_depth/2-wall_thickness)*x,0,(bearing_body_thickness/2-wall_thickness)*y]) {
          rotate([90,0,0]) {
            hole(wall_thickness*2,mount_thickness,resolution);
          }
        }
      }
    }
  }

  module bearing_pos() {
    translate([line_x,bearing_y,bearing_z]) {
      rotate([0,90,0]) {
        translate([0,0,0]) {
          children();
        }
      }
    }
  }

  module body() {
    hull() {
      // rod body
      translate([0,-mount_thickness/2,0]) {
        rotate([90,0,0]) {
          hole(y_rod_diam+wall_thickness*3,mount_thickness,resolution);
        }
      }
      translate([0,-mount_thickness/2,0]) {
        // side sheet screw hole
        translate([endcap_side_screw_hole_pos_x,0,endcap_side_screw_hole_pos_z]) {
          rotate([90,0,0]) {
            hole(bc_screw_diam+wall_thickness*3,mount_thickness,resolution);
          }
        }
        // top sheet screw hole
        translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
          rotate([90,0,0]) {
            hole(bc_screw_diam+wall_thickness*3,mount_thickness,resolution);
          }
        }
      }
      bearing_pos() {
        translate([0,-bearing_y-mount_thickness/2,0]) {
          bearing_base();
        }
      }
    }
    bearing_pos() {
      % line_bearing();
      hull() {
        translate([0,-bearing_y-mount_thickness/2,0]) {
          bearing_base();
        }
        hole(bearing_body_diam,bearing_body_thickness,resolution);
      }
    }
  }

  module holes() {
    // side sheet screw hole
    translate([endcap_side_screw_hole_pos_x,0,endcap_side_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
        bevel_hole(3,.5,16);
      }
    }
    // top sheet screw hole
    translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
        bevel_hole(3,.5,16);
      }
    }

    for(side=[top,bottom]) {
      translate([line_x,0,bearing_z+line_bearing_effective_diam/2*side]) {
        rotate([90,0,0]) {
          hole(3,60,resolution);
          bevel_hole(3,.5,resolution);
        }
      }
    }

    bearing_pos() {
      hole(line_bearing_diam+spacer*2,line_bearing_thickness+line_bearing_washer_thickness*2,resolution);
      hole(3,60,8);

      translate([0,0,bearing_body_thickness/2]) {
        rotate([0,0,90]) {
          hole(line_bearing_nut_diam,line_bearing_nut_thickness,6);
        }
      }
    }

    // y rod
    rotate([90,0,0]) {
      % hole(y_rod_diam,mount_thickness*2+1,16);
    }
  }

  module bridges() {
    bearing_pos() {
      line_bearing_bevel();
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module rear_xy_endcap() {
  mount_thickness = 6;

  line_x          = xy_line_x-y_rod_x;
  line_to_motor_x = line_x + 2;
  line_to_motor_z = opposite_to_motor_line_z;

  high_bearing_y = spacer+line_bearing_diam/2;
  mid_bearing_y  = high_bearing_y+line_bearing_nut_diam/2+wall_thickness+line_bearing_diam/2;
  low_bearing_y  = motor_side/2-pulley_diam/2;
  line_to_motor_x = endcap_top_screw_hole_pos_x+line_bearing_effective_diam/2;
  line_to_motor_z = endcap_top_screw_hole_pos_z+line_bearing_effective_diam/2;

  low_high_dist_x          = xy_line_x*2+line_to_motor_x;
  low_high_dist_y          = low_bearing_y - high_bearing_y - line_bearing_diam/2;
  low_to_high_line_angle_z = atan2(low_high_dist_y,low_high_dist_x);
  high_to_low_line_angle_y = -atan2(top_line_z - line_to_motor_z,line_x-line_to_motor_x+xy_line_x*2);

  module bearing_base() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([(bearing_body_depth/2-wall_thickness)*x,0,(bearing_body_thickness/2-wall_thickness)*y]) {
          rotate([90,0,0]) {
            hole(wall_thickness*2,mount_thickness,resolution);
          }
        }
      }
    }
  }

  module high_bearing_pos() {
    translate([line_x,high_bearing_y,top_line_z]) {
      rotate([0,high_to_low_line_angle_y,0]) {
        translate([-line_bearing_effective_diam/2,0,0]) {
          children();
        }
      }
    }
  }

  module mid_bearing_pos() {
    translate([line_x,mid_bearing_y,mid_line_z-line_bearing_effective_diam/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module low_bearing_pos() {
    translate([line_to_motor_x,motor_side/2-pulley_diam/2,line_to_motor_z-line_bearing_effective_diam/2]) {
      rotate([0,0,low_to_high_line_angle_z]) {
        translate([-line_bearing_effective_diam/2,0,0]) {
          rotate([-90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module lower_bearing_mount_base() {
    translate([line_to_motor_x-line_bearing_effective_diam/2,mount_thickness/2,line_to_motor_z-line_bearing_effective_diam/2]) {
      rotate([90,0,0]) {
        hole(bearing_body_diam+wall_thickness*2,mount_thickness,resolution);
      }
    }
  }

  module body() {
    hull() {
      // rod body
      translate([0,mount_thickness/2,0]) {
        rotate([90,0,0]) {
          hole(y_rod_diam+wall_thickness*3,mount_thickness,resolution);
        }
      }
      translate([0,mount_thickness/2,0]) {
        // side sheet screw hole
        translate([endcap_side_screw_hole_pos_x,0,endcap_side_screw_hole_pos_z]) {
          rotate([90,0,0]) {
            hole(bc_screw_diam+wall_thickness*3,mount_thickness,resolution);
          }
        }
        // top sheet screw hole
        translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
          rotate([90,0,0]) {
            hole(bc_screw_diam+wall_thickness*3,mount_thickness,resolution);
          }
        }
      }
      high_bearing_pos() {
        % line_bearing();
        translate([0,-high_bearing_y+mount_thickness/2,0]) {
          bearing_base();
        }
      }
      mid_bearing_pos() {
        % line_bearing();
        translate([0,-mid_bearing_y+mount_thickness/2,0]) {
          bearing_base();
        }
      }
      lower_bearing_mount_base();
    }
    hull() {
      high_bearing_pos() {
        translate([0,-high_bearing_y+mount_thickness/2,0]) {
          bearing_base();
        }
        translate([0,0,-line_bearing_thickness*2]) {
          hole(line_bearing_nut_diam+wall_thickness*2,line_bearing_nut_thickness+wall_thickness*2,resolution);
        }
        hole(bearing_body_diam,bearing_body_thickness,resolution);
      }
      lower_bearing_mount_base();
    }
    mid_bearing_pos() {
      hull() {
        translate([0,-mid_bearing_y+mount_thickness/2,0]) {
          bearing_base();
        }
        hole(bearing_body_diam,bearing_body_thickness,resolution);
      }
    }
    hull() {
      low_bearing_pos() {
        % line_bearing();
        translate([0,0,-line_bearing_thickness/2-1]) {
          hole(line_bearing_inner+wall_thickness,2,resolution);
        }
        translate([0,0,-line_bearing_thickness*1.75]) {
          hole(bearing_body_diam+wall_thickness*2,2,resolution);
        }
      }

      lower_bearing_mount_base();
    }
    hull() {
      translate([0,mount_thickness,0]) {
        rotate([90,0,0]) {
          hole(y_rod_diam+wall_thickness*3,mount_thickness*2,resolution);
        }
        translate([y_rod_diam/2+m3_nut_diam/2,0,0]) {
          cube([m3_nut_diam+wall_thickness*2,mount_thickness*2,y_rod_diam+wall_thickness*3],center=true);
        }
      }
    }
  }

  module line_path() {
    hull() {
      for(z=[top_line_z,mid_line_z]) {
        translate([line_x,0,z]) {
          rotate([90,0,0]) {
            hole(3,50,16);
          }
        }
      }
    }
    hull() {
      for(z=[top_line_z,mid_line_z]) {
        translate([line_x,0,z]) {
          rotate([90,0,0]) {
            bevel_hole(3,.5,16);
          }
        }
      }
    }
  }

  module holes() {
    // side sheet screw hole
    translate([endcap_side_screw_hole_pos_x,0,endcap_side_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
        bevel_hole(3,.5,16);
      }
    }
    // top sheet screw hole
    translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
        bevel_hole(3,.5,16);
      }
    }
    line_path();
    high_bearing_pos() {
      // bolt
      hole(3,line_bearing_thickness*8,8);
      hole(line_bearing_diam+spacer,line_bearing_thickness+line_bearing_washer_thickness*2,resolution);
      translate([0,50,0]) {
        cube([line_bearing_diam+spacer,100,line_bearing_thickness+line_bearing_washer_thickness*2],center=true);
      }
      // captive nut
      translate([0,0,-line_bearing_thickness*2-line_bearing_nut_thickness/2]) {
        hole(line_bearing_nut_diam,line_bearing_nut_thickness,6);
        translate([0,-25,0]) {
          cube([line_bearing_nut_diam,50,line_bearing_nut_thickness],center=true);
        }
      }
    }
    mid_bearing_pos() {
      hole(3,60,8);
      translate([0,0,-bearing_body_thickness/2]) {
        // captive nut
        rotate([0,0,90]) {
          hole(line_bearing_nut_diam,line_bearing_nut_thickness,6);
        }
      }
      cube([line_bearing_diam+spacer*4,line_bearing_diam+spacer,line_bearing_thickness+line_bearing_washer_thickness*2],center=true);
    }
    low_bearing_pos() {
      translate([0,0,20]) {
        hole(line_bearing_diam+spacer*2,line_bearing_thickness+line_bearing_washer_thickness*2+40,resolution);
      }
      hole(3,60,resolution);
      translate([0,0,-low_bearing_y]) {
        //hole(line_bearing_nut_diam,line_bearing_nut_thickness*2,6);
      }
    }

    // y rod
    rotate([90,0,0]) {
      hole(y_rod_diam+0.1,mount_thickness*4+1,16);
      bevel_hole(y_rod_diam+0.1,.5,16);
    }
    translate([y_rod_diam/2+m3_nut_diam/2,0,0]) {
      translate([0,mount_thickness+extrusion_height,0]) {
        cube([y_rod_diam*2,mount_thickness*2,2],center=true);

        hole(m3_diam,y_rod_diam*2,8);
        translate([0,0,-y_rod_diam/2-wall_thickness*1.5-m3_nut_thickness/2]) {
          rotate([0,0,90]) {
            hole(m3_nut_diam,m3_nut_thickness*2,6);
          }
        }
      }
    }
  }

  module bridges() {
    difference() {
      high_bearing_pos() {
        line_bearing_bevel();
      }
      line_path();
    }
    mid_bearing_pos() {
      line_bearing_bevel();
    }
    low_bearing_pos() {
      line_bearing_bevel([front]);
    }
  }

  % low_bearing_pos() {
    rotate([0,0,high_to_low_line_angle_y]) {
      translate([-xy_line_x,line_bearing_effective_diam/2,0]) {
        //cube([xy_line_x*2,.5,.5],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module z_idler_top() {
  body_width = z_brace_body_width;
  size       = top_rear_brace_depth;

  module body() {
    hull() {
      translate([0,-1,-1]) {
        cube([body_width,2,2],center=true);
      }
      translate([0,-size+1,-1]) {
        cube([body_width,2,2],center=true);
      }
      translate([0,-3,-size+1]) {
        cube([body_width,6,2],center=true);
      }
    }
  }

  module holes() {
    // screw to top plate
    translate([0,-z_brace_screw_dist_from_corner,0]) {
      hole(3,40,8);
      translate([0,0,-6-20]) {
        hole(m3_nut_diam,40,6);
      }
    }
    // screw to rear plate
    translate([0,0,-z_brace_screw_dist_from_corner]) {
      rotate([-90,0,0]) {
        hole(3,40,8);
        translate([0,0,-6-20]) {
          hole(m3_nut_diam,40,6);
        }
      }
    }
    translate([0,front*z_pulley_sheet_dist_y,bottom*z_pulley_sheet_dist_z]) {
      rotate([0,90,0]) {
        hole(5,40,16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_idler_bottom() {
  body_width = m3_nut_diam + wall_thickness*2;
  body_depth = top_rear_brace_depth;
  body_pos_x = z_pulley_height/2 + spacer + body_width/2;

  module body() {
    hull() {
      translate([0,z_line_bearing_to_top_pos_y,z_line_bearing_to_top_pos_z]) {
        cube([body_width,2*(abs(z_line_bearing_to_top_pos_y)),body_width],center=true);
      }
      translate([0,-1,+1]) {
        cube([body_width,2,2],center=true);
      }
      translate([0,-body_depth+1,+1]) {
        cube([body_width,2,2],center=true);
      }
    }
  }

  module holes() {
    // bearing idler to top pulley idler
    translate([0,front*z_line_bearing_diam/2,motor_side/2+z_line_bearing_diam/2]) {
      rotate([0,90,0]) {
        hole(z_line_bearing_inner,40,16);
      }
    }
    // pulley idler to carriage
    translate([0,z_line_bearing_to_carriage_pos_y,z_line_bearing_to_carriage_pos_z]) {
      rotate([0,90,0]) {
        hole(5,40,16);
      }
    }
    // screw to top plate
    translate([0,-z_brace_screw_dist_from_corner,0]) {
      hole(3,40,8);
      translate([0,0,6+20]) {
        hole(m3_nut_diam,40,6);
      }
    }
    // screw to rear plate
    translate([0,0,z_brace_screw_dist_from_corner]) {
      rotate([-90,0,0]) {
        hole(3,40,8);
        translate([0,0,-6-20]) {
          hole(m3_nut_diam,40,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_stationary() {
  z_line_bearing_diam = 10;
  //z_belt_pulley_diam  = 10;
  motor_pos_z         = top_sheet_pos_z-sheet_thickness/2-motor_side/2;
  motor_pos_z         = bottom_sheet_pos_z+sheet_thickness/2+motor_side/2;

  // z rods
  for (side=[left,right]) {
    translate([z_rod_pos_x*side,z_rod_pos_y,z_rod_pos_z]) {
      % cylinder(r=z_rod_diam/2,h=z_rod_len+0.1,center=true);
    }
  }

  translate([left*z_motor_pos_x,z_motor_pos_y,z_motor_pos_z]) {
    % rotate([0,90,0]) {
      translate([0,0,z_motor_pos_x]) {
        hole(z_pulley_diam,z_pulley_height,resolution);
      }
      motor();
    }
  }
  translate([0,z_rod_pos_y,z_motor_pos_z]) {
    rotate([0,90,0]) {
      % difference() {
        //hole(z_pulley_diam,z_line_bearing_thickness,resolution);
        //hole(6,z_line_bearing_thickness+1,resolution);
      }
    }
  }

  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([z_brace_pos_x,sheet_pos_y-sheet_thickness/2,top_sheet_pos_z-sheet_thickness/2]) {
        z_idler_top();
      }

      translate([z_brace_pos_x,sheet_pos_y-sheet_thickness/2,bottom_sheet_pos_z+sheet_thickness/2]) {
        z_idler_bottom();
      }
    }
  }
  // top z belt bearings
  % translate([0,sheet_pos_y-sheet_thickness/2,top_sheet_pos_z-sheet_thickness/2]) {
    translate([0,front*z_pulley_sheet_dist_y,bottom*z_pulley_sheet_dist_z]) {
      rotate([0,90,0]) {
        difference() {
          hole(z_pulley_diam,z_pulley_height,resolution);
          hole(5,z_pulley_height+1,8);
        }
      }
    }
  }
  // bottom z belt bearings
  % translate([0,sheet_pos_y-sheet_thickness/2,bottom_sheet_pos_z+sheet_thickness/2]) {
    translate([0,front*z_line_bearing_diam/2,motor_side/2+z_line_bearing_diam/2]) {
      rotate([0,90,0]) {
        difference() {
          hole(z_line_bearing_diam,z_line_bearing_thickness,resolution);
          hole(z_line_bearing_inner,z_line_bearing_thickness+1,8);
        }
      }
    }
    // pulley idler to carriage
    translate([0,z_line_bearing_to_carriage_pos_y,z_line_bearing_to_carriage_pos_z]) {
      rotate([0,90,0]) {
        difference() {
          hole(z_pulley_diam,z_pulley_height,resolution);
          hole(5,z_pulley_height+1,8);
        }
      }

      /*
      translate([0,-z_pulley_diam/2-belt_thickness/2,80]) {
        cube([belt_width,belt_thickness,200],center=true);

        translate([0,-z_line_bearing_diam-belt_thickness,0]) {
          cube([belt_width,belt_thickness,200],center=true);
        }
      }
      */
    }
  }
}

module z_carriage_bearing_support_arm() {
  bearing_to_arm_support_dist_y = front*(-z_carriage_bearing_offset_y -z_bearing_body_diam/2 - z_bed_support_mount_depth);

  module body() {
    intersection() {
      hull() {
        for(side=[top,bottom]) {
          translate([z_carriage_bearing_spacing/2*side,0]) {
            accurate_circle(z_line_bearing_diam,resolution);
          }
        }

        translate([0,-bearing_to_arm_support_dist_y-9,0]) {
          square([abs(z_carriage_bearing_offset_z)*2,20],center=true);
        }
      }
      translate([0,-bearing_to_arm_support_dist_y+11,0]) {
        box_side([z_printed_portion_height,22],[0,0,3,0]);
      }
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([z_carriage_bearing_spacing/2*side,0]) {
          accurate_circle(z_line_bearing_inner,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module printed_z_portion() {
  module body() {
    hull() {
      translate([z_rod_pos_x,0,0]) {
        hole(z_bearing_body_diam,z_printed_portion_height,resolution);
      }
      translate([(z_bed_support_pos_x-sheet_thickness/2-z_bed_support_mount_width/2),-z_bearing_body_diam/2+1,0]) {
        cube([z_bed_support_mount_width,2,z_printed_portion_height],center=true);
      }
    }

    translate([(z_bed_support_pos_x-sheet_thickness/2-z_bed_support_mount_width/2),-z_bearing_body_diam/2-z_bed_support_mount_depth/2,0]) {
      cube([z_bed_support_mount_width,z_bed_support_mount_depth,z_printed_portion_height],center=true);

      translate([-(z_bed_support_mount_width/2+z_bed_support_mount_depth/2),0,0]) {
        cube([z_bed_support_mount_depth,z_bed_support_mount_depth,z_printed_portion_height],center=true);
      }
    }
  }

  module holes() {
    translate([z_rod_pos_x,0,0]) {
      hole(z_bearing_diam,z_printed_portion_height+1,resolution);

      translate([z_bearing_body_diam/2,0,extrusion_height]) {
        cube([z_bearing_body_diam,5,z_printed_portion_height],center=true);
      }
    }

    // arm mounting holes
    translate([(z_bed_support_pos_x-sheet_thickness/2-z_bed_support_mount_depth/2),0,0]) {
      for(z=[-2,-1,0,1,2]) {
        translate([-15,-z_bearing_body_diam/2-z_bed_support_mount_depth/2,z_support_arm_hole_spacing*z]) {
          rotate([0,90,0]) {
            hole(m3_nut_diam,30,6);
            hole(3,z_bearing_body_diam*3,8);
          }
        }
      }
    }

    // z axis main plate mounting holes
    translate([(z_bed_support_pos_x-sheet_thickness/2-z_bed_support_mount_depth-m3_nut_diam/2),15,0]) {
      for(z=[1:z_support_arm_hole_count]) {
        translate([0,-z_bearing_body_diam/2-z_bed_support_mount_depth/2,z_printed_portion_height/2-z_support_arm_hole_spacing*z]) {
          rotate([90,0,0]) {
            rotate([0,0,90]) {
              hole(m3_nut_diam,30,6);
              hole(3,z_bearing_body_diam*3,8);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_bed_plate() {
  support_arm_rod_dist_y = z_bearing_body_diam/2+z_build_platform_depth/2;
  fill_to_arm            = abs(abs(z_rod_pos_y-support_arm_rod_dist_y) - abs(build_pos_y));

  module body() {
    rounded_diam = 10;
    depth = z_build_platform_depth+fill_to_arm;
    translate([0,fill_to_arm/2,0]) {
      hull() {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(z_build_platform_width/2-rounded_diam/2)*x,(depth/2-rounded_diam/2)*y,0]) {
              accurate_circle(rounded_diam,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([z_bed_support_pos_x*x,fill_to_arm,0]) {
        rotate([0,0,90]) {
          box_holes_for_side(z_build_platform_depth,4);
        }
      }
      for(y=[front,rear]) {
        translate([heatbed_hole_spacing_x/2*x,heatbed_hole_spacing_y/2*y,0]) {
          accurate_circle(heatbed_hole_diam,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_main_plate() {
  width                  = z_bed_support_pos_x*2-sheet_thickness;

  module body() {
    square([width,z_printed_portion_height],center=true);
  }

  module holes() {
    for(side=[left,right]) {
      translate([side*(z_line_bearing_thickness/2+sheet_thickness/2+spacer),z_printed_portion_height/2+z_carriage_bearing_offset_z,0]) {
        rotate([0,0,90]) {
          box_holes_for_side(z_printed_portion_height,4);
        }
      }

      translate([side*(width/2-z_bed_support_mount_depth-m3_nut_diam/2),0,0]) {
        for(z=[1:z_support_arm_hole_count]) {
          translate([0,z_printed_portion_height/2-z_support_arm_hole_spacing*z,0]) {
            accurate_circle(3,resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

// laser cut support arm
module z_support_arm() {
  angle_length = build_y*.9;
  angle_height = z_printed_portion_height*.7;

  flat_bottom_len = sheet_thickness+z_bed_support_mount_depth;
  rounded_diam = 10;

  difference() {
    intersection() {
      box_side([z_build_platform_depth,z_printed_portion_height],[3,0,0,0]);
      hull() {
        translate([-z_build_platform_depth/2,z_printed_portion_height/2]) {
          square([flat_bottom_len*2,z_printed_portion_height*2],center=true);
        }
        translate([z_build_platform_depth/2,z_printed_portion_height/2]) {
          square([2,10],center=true);
        }
        translate([z_build_platform_depth/2-rounded_diam/2,z_printed_portion_height/2-flat_bottom_len+rounded_diam/2]) {
          accurate_circle(rounded_diam,resolution);
        }
      }
    }

    translate([-z_build_platform_depth/2+z_bed_support_mount_depth/2,0]) {
      for(z=[-2,-1,0,1,2]) {
        translate([0,z_support_arm_hole_spacing*z]) {
          accurate_circle(3,resolution);
        }
      }
    }
  }
}

module z_axis() {
  build_base_z = build_pos_z-build_z/2-heatbed_and_glass_thickness-sheet_thickness/2;

  module z_build_plate() {
    difference() {
      cube([heatbed_width,heatbed_depth,heatbed_thickness],center=true);

      for(x=[left,right]) {
        for(y=[front,rear]) {
          translate([heatbed_hole_spacing_x/2*x,heatbed_hole_spacing_y/2*y,0]) {
            hole(heatbed_hole_diam,heatbed_thickness+1,8);
          }
        }
      }
    }
  }

  translate([0,z_rod_pos_y,build_base_z-z_printed_portion_height/2]) {
    for(side=[left,right]) {
      mirror([1-side,0,0]) {
        printed_z_portion();
      }
    }

    for(side=[left,right]) {
      // z bearings
      for(end=[top,bottom]) {
        translate([z_rod_pos_x*side,0,end*(z_bearing_len/2 + z_bearing_spacing/2)]) {
          % hole(z_bearing_diam,z_bearing_len,16);
        }
      }

      // support arms
      translate([z_bed_support_pos_x*side,-z_bearing_body_diam/2-z_build_platform_depth/2-0.1,0]) {
        rotate([0,0,-90]) {
          rotate([90,0,0]) {
            color("purple") linear_extrude(height=sheet_thickness,center=true) z_support_arm();
          }
        }
      }

      translate([side*(z_line_bearing_thickness/2+sheet_thickness/2+spacer),z_carriage_bearing_offset_y,z_printed_portion_height/2+z_carriage_bearing_offset_z]) {
        rotate([0,90,0]) {
          linear_extrude(height=sheet_thickness,center=true) z_carriage_bearing_support_arm();
        }
      }
    }
  }

  translate([0,z_rod_pos_y-z_bearing_body_diam/2-z_bed_support_mount_depth-sheet_thickness/2,build_base_z-z_printed_portion_height/2]) {
    rotate([90,0,0]) {
      color("orange") linear_extrude(height=sheet_thickness,center=true) z_main_plate();
    }
  }

  translate([build_pos_x,build_pos_y,build_base_z+sheet_thickness/2]) {
    translate([0,0,sheet_thickness/2+1]) {
      color("red") {
        z_build_plate();
      }
    }

    linear_extrude(height=sheet_thickness,center=true) z_bed_plate();
  }
}

module tuner() {
  adjuster_narrow_neck_len = 2;
  adjuster_len = 24 - tuner_body_diam + adjuster_narrow_neck_len;
  adjuster_large_diam = 8;
  adjuster_tuner_thin_diam = 6;
  adjuster_x = tuner_body_pos;
  adjuster_y = tuner_body_square_len/2;
  adjuster_shaft_z = tuner_body_diam/2+adjuster_len/2;
  adjuster_paddle_len = 20;
  adjuster_paddle_z = adjuster_shaft_z + adjuster_len/2 + adjuster_paddle_len/2;
  adjuster_paddle_width = 17.8;
  adjuster_paddle_thickness = adjuster_tuner_thin_diam;

  module body() {
    //% translate([-tuner_hole_to_shoulder/2,-thick_diam,0]) rotate([0,90,0]) cylinder(r=tuner_thin_diam/4,h=tuner_hole_to_shoulder,center=true);

    // thin shaft
    translate([-tuner_thin_pos,0,0]) rotate([0,90,0])
      hole(tuner_thin_diam,tuner_thin_len,resolution);

    // thick shaft (area to clamp)
    translate([-thick_pos,0,0]) rotate([0,90,0])
      hole(thick_diam,thick_len,resolution);

    // body
    translate([tuner_body_pos,0,0]) {
      hull() {
        rotate([0,90,0]) {
          hole(tuner_body_diam,tuner_body_thickness,resolution);
        }
        translate([0,tuner_body_square_len/2,0]) {
          cube([tuner_body_thickness,tuner_body_square_len,tuner_body_diam],center=true);
        }
      }
    }

    // anchor screw hole
    translate([tuner_anchor_screw_hole_pos_x,0,0]) {
      hull() {
        translate([0,tuner_anchor_screw_hole_pos_y,tuner_anchor_screw_hole_pos_z]) rotate([0,90,0])
          hole(tuner_anchor_screw_hole_diam+tuner_anchor_screw_hole_width*2,tuner_anchor_screw_hole_thickness,resolution);
        rotate([0,90,0])
          hole(thick_diam,tuner_anchor_screw_hole_thickness);
      }
    }

    // twist adjuster
    translate([adjuster_x,adjuster_y,adjuster_shaft_z]) {
      hull() {
        translate([0,0,-adjuster_len/2-.5]) hole(adjuster_large_diam,1,resolution);
        translate([0,0,+adjuster_len/2-.5]) hole(adjuster_tuner_thin_diam,1,resolution);
      }
      // paddle, representing space taken when rotated
      hull() {
        //translate([0,0,adjuster_paddle_len/2]) cylinder(r=adjuster_paddle_width/2,h=1,center=true);
        //translate([0,0,1]) cylinder(r=adjuster_paddle_thickness/2,h=1,center=true);
        translate([0,0,adjuster_paddle_len-.5]) cube([adjuster_paddle_width,adjuster_paddle_thickness,1],center=true);
        translate([0,0,adjuster_len/2]) cube([adjuster_paddle_thickness,adjuster_paddle_thickness,1],center=true);
      }
    }
  }

  module holes() {
    cylinder(r=wire_hole_diam/3,h=tuner_thin_diam*2,center=true);

    translate([tuner_anchor_screw_hole_pos_x,tuner_anchor_screw_hole_pos_y,tuner_anchor_screw_hole_pos_z]) rotate([0,90,0])
      hole(tuner_anchor_screw_hole_diam,tuner_anchor_screw_hole_thickness+1,8);
  }

  difference() {
    body();
    holes();
  }
}
