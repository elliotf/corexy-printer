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
  hole(3,sheet_thickness+1,resolution);
}

module zip_tie_hole(diam,width=zip_tie_width,thickness=zip_tie_thickness) {
  difference() {
    hole(diam+thickness*2,width,resolution);
    hole(diam,width+.1,resolution);
  }
}

module belt_bearing() {
  res = 64;

  module body() {
    for(side=[top,bottom]) {
      hull() {
        translate([0,0,-side*(belt_bearing_thickness/4)]) {
          hole(belt_bearing_effective_diam,belt_bearing_thickness/2,res);
        }
        translate([0,0,-side*(belt_bearing_thickness/2-0.05)]) {
          hole(belt_bearing_diam,0.1,res);
        }
      }
    }
  }

  module holes() {
    hole(belt_bearing_inner, belt_bearing_thickness+1,res);
  }

  difference() {
    body();
    holes();
  }
}

module belt_bearing_bevel(sides=[top,bottom]) {
  difference() {
    for(side=sides) {
      translate([0,0,(belt_bearing_thickness/2+belt_bearing_washer_thickness)*side]) {
        hull() {
          hole(belt_bearing_inner+1,belt_bearing_washer_thickness*2,8);
          translate([0,0,belt_bearing_washer_thickness*side]) {
            hole(belt_bearing_inner+4,belt_bearing_washer_thickness,8);
          }
        }
      }
    }

    hole(belt_bearing_inner,belt_bearing_thickness*3,8);
  }
}

% for (end=[left,right]) {
  // y rods
  translate([y_rod_x*end,0,0]) {
    rotate([90,0,0]) {
      cylinder(r=rod_diam/2,h=y_rod_len+2,center=true,$fn=16);
    }
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

module x_carriage() {
  res = 16;

  body_side = rear;

  module body() {
    translate([0,(x_carriage_thickness/2-rod_diam/2)*body_side,0]) {
      cube([x_carriage_width,x_carriage_thickness,x_carriage_height],center=true);
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        translate([0,x_carriage_thickness/2*-body_side,0]) {
          cube([bearing_len,x_carriage_thickness,bearing_diam-1],center=true);
          cube([x_carriage_width+1,x_carriage_thickness,rod_diam+1],center=true);
        }
        rotate([0,90,0]) {
          hole(bearing_diam,bearing_len,res);
          hole(rod_diam+1,x_carriage_width+2,res);
        }
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
        cylinder(r=bearing_diam/2,h=bearing_len,center=true);
      }
    }
  }

  translate([0,hotend_y,hotend_z]) {
    % cylinder(r=hotend_diam/2,h=hotend_len,center=true);
  }
}

module y_carriage() {
  belt_bearing_x = (y_rod_x - y_carriage_belt_bearing_x);
  belt_bearing_opening_height = belt_bearing_thickness*2+belt_bearing_washer_thickness*3;

  rod_hole_diam = rod_diam + rod_slop;

  x_rod_clamp_len = belt_bearing_x + belt_bearing_nut_diam/2 + min_material_thickness*2;
  x_rod_clamp_len = y_carriage_width;

  module body() {
    // main body, hold x rods
    hull() {
      for(side=[top,bottom]) {
        translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            hole(rod_hole_diam+min_material_thickness*4,x_rod_clamp_len,resolution);
          }
        }
      }
      intersection() {
        translate([bearing_diam/2,0,0]) {
          cube([bearing_diam,y_carriage_depth*2,bearing_diam*2],center=true);
        }
        rotate([90,0,0]) {
          hole(bearing_diam+min_material_thickness*8,y_carriage_depth,resolution);
        }
      }
      translate([x_rod_clamp_len/2,y_carriage_belt_bearing_y,0]) {
        cube([x_rod_clamp_len,belt_bearing_nut_diam+min_material_thickness*4,y_carriage_height],center=true);
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
        zip_tie_hole(bearing_diam+min_material_thickness*2);
      }
    }

    // y rod bearing and clamp
    translate([0,0,0]) {
      rotate([90,0,0]) {
        hole(bearing_diam,bearing_len*2,resolution);
      }
    }

    // bearing/line-related holes
    translate([belt_bearing_x,y_carriage_belt_bearing_y,y_carriage_belt_bearing_z]) {
      // bearing/clamp screw
      hole(belt_bearing_inner+rod_slop,50,8);

      hull() {
        hole(belt_bearing_diam + spacer*2,belt_bearing_opening_height,resolution);
        // room for belt/filament
        translate([0,belt_bearing_diam/2,0]) {
          cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_opening_height],center=true);
        }
        translate([belt_bearing_diam/2,0,0]) {
          cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_opening_height],center=true);
        }
      }

      // rear to front line return
      translate([-belt_bearing_effective_diam/2,0,-belt_bearing_thickness/2+belt_bearing_effective_diam+0.25]) {
        rotate([90,0,0]) {
          hole(2,60,8);
        }
      }

      // through carriage hole to front
      translate([-belt_bearing_effective_diam/2-0.5,0,-(belt_bearing_thickness/2)]) {
        rotate([90,0,0]) {
          hole(2,60,8);
        }
      }

      for (side=[top,bottom]) {
        translate([0,0,(belt_bearing_thickness/2+belt_bearing_washer_thickness/2)*side]) {
          % belt_bearing();
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  translate([0,0,0]) {
    rotate([90,0,0]) {
      % cylinder(r=bearing_diam/2,h=bearing_len,center=true);
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
  bottom_material  = 30;
  opening_height   = min((sheet_height - bottom_material),(sheet_height*.60));

  module body() {
    box_side([front_sheet_width,sheet_height],[0,4,4,4]);
  }

  module holes() {
    translate([0,-sheet_pos_z,0]) {
      translate([0,top_sheet_pos_z,0]) {
        box_holes_for_side(front_sheet_width,4);
      }

      for(side=[left,right]) {
        translate([y_rod_x*side,0,0]) {
          hole(rod_diam-laser_cut_kerf*2,sheet_thickness+1,64);
        }

        translate([(y_carriage_belt_bearing_x+belt_bearing_effective_diam/2)*side,y_carriage_belt_bearing_z-belt_bearing_washer_thickness/2-belt_bearing_thickness/2,0]) {
          line_hole();

          translate([0,belt_bearing_effective_diam,0]) {
            line_hole();
          }
        }
      }
    }

    front_opening_width = main_opening_width - sheet_thickness*2;
    hull() {
      translate([0,sheet_height/2,0]) {
        cube([build_x-sheet_thickness*2,opening_height*2,sheet_thickness+1],center=true);
        cube([front_opening_width-sheet_thickness*2,hotend_sheet_clearance*2,sheet_thickness+1],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rear_sheet() {
  module body() {
    box_side([front_sheet_width,sheet_height],[0,4,4,4]);
  }

  module holes() {
    translate([0,-sheet_pos_z,0]) {
      translate([0,top_sheet_pos_z,0]) {
        box_holes_for_side(front_sheet_width,4);
      }
      for(side=[left,right]) {
        translate([y_rod_x*side,0,0]) {
          hole(rod_diam-laser_cut_kerf*2,sheet_thickness+1,64);
        }

        hull() {
          translate([(y_carriage_belt_bearing_x+belt_bearing_effective_diam/2)*side,y_carriage_belt_bearing_z]) {
            translate([0,-belt_bearing_washer_thickness/2-belt_bearing_thickness/2+belt_bearing_effective_diam,0]) {
              line_hole();
            }

            translate([0,belt_bearing_washer_thickness/2+belt_bearing_thickness/2,0]) {
              line_hole();
            }
          }
        }
      }

      translate([z_motor_pos_x,z_motor_pos_z,0]) {
        hole(z_motor_shoulder_diam,sheet_thickness*2,resolution);

        for(x=[left,right]) {
          for(y=[top,bottom]) {
            translate([z_motor_hole_spacing/2*x,z_motor_hole_spacing/2*y,0]) {
              hole(z_motor_screw_diam,sheet_thickness*2,resolution);
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

  module holes() {
    translate([0,-sheet_pos_z+top_sheet_pos_z,0]) {
      box_holes_for_side(side_sheet_depth,4);
    }

    translate([0,-sheet_pos_z+top_sheet_pos_z-sheet_thickness*1.5-opening_height/2,0]) {
      cube([side_sheet_depth/2,opening_height,sheet_thickness+1],center=true);
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
    hole_diam = hotend_diam*0.8;
    front_y   = front*top_sheet_depth/2;

    front_opening_width = main_opening_width - sheet_thickness*2;

    hull() {
      for(x=[left,right]) {
        for(y=[front_y+hole_diam,front_y+main_opening_depth-hole_diam/2]) {
          translate([x*(main_opening_width/2-hole_diam/2),y,0]) {
            hole(hole_diam,sheet_thickness+2,resolution);
          }
        }
      }
      translate([0,front*(top_sheet_depth/2-sheet_thickness/2+0.05),0]) {
        cube([front_opening_width-hole_diam,sheet_thickness,sheet_thickness+1],center=true);
      }
    }
    translate([0,front*(top_sheet_depth/2),0]) {
      cube([front_opening_width-hole_diam,sheet_thickness*4,sheet_thickness+1],center=true);
    }

    for(side=[left,right]) {
      translate([z_rod_pos_x*side,z_rod_pos_y,0]) {
        hole(rod_diam-laser_cut_kerf*2,sheet_thickness+1,64);
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
        hole(rod_diam-laser_cut_kerf*2,sheet_thickness+1,64);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_xy_endcap() {
  mount_thickness = 5;
  wall_thickness  = extrusion_width*4;

  line_x = xy_line_x-y_rod_x;

  bearing_y = front*(mount_thickness+belt_bearing_nut_diam/2+spacer);
  bearing_z = top_line_z-belt_bearing_effective_diam/2;

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
          hole(rod_diam+wall_thickness*3,mount_thickness,resolution);
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
      % belt_bearing();
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
      }
    }
    // top sheet screw hole
    translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
      }
    }

    bearing_pos() {
      hole(belt_bearing_diam+spacer*2,belt_bearing_thickness+belt_bearing_washer_thickness*2,resolution);
      hole(3,60,8);

      translate([0,0,bearing_body_thickness/2]) {
        rotate([0,0,90]) {
          hole(belt_bearing_nut_diam,belt_bearing_nut_thickness*2,6);
        }
      }

      for(side=[top,bottom]) {
        translate([belt_bearing_effective_diam/2*side,0,0]) {
          rotate([90,0,0]) {
            hole(3,60,resolution);
          }
        }
      }
    }

    // y rod
    rotate([90,0,0]) {
      % hole(rod_diam,mount_thickness*2+1,16);
    }
  }

  module bridges() {
    bearing_pos() {
      belt_bearing_bevel();
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module rear_xy_endcap() {
  mount_thickness = 5;

  line_x          = xy_line_x-y_rod_x;
  line_to_motor_x = line_x + 2;
  line_to_motor_z = low_line_z;

  high_bearing_y = spacer+belt_bearing_diam/2;
  mid_bearing_y  = high_bearing_y+belt_bearing_nut_diam/2+wall_thickness+spacer+belt_bearing_diam/2;
  low_bearing_y  = motor_side/2-pulley_diam/2;

  low_high_dist_x          = xy_line_x*2+line_to_motor_x;
  low_high_dist_y          = low_bearing_y - high_bearing_y - belt_bearing_diam/2;
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
        translate([-belt_bearing_effective_diam/2,0,0]) {
          children();
        }
      }
    }
  }

  module mid_bearing_pos() {
    translate([line_x,mid_bearing_y,mid_line_z-belt_bearing_effective_diam/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module low_bearing_pos() {
    translate([line_to_motor_x,motor_side/2-pulley_diam/2,line_to_motor_z-belt_bearing_effective_diam/2]) {
      rotate([0,0,low_to_high_line_angle_z]) {
        translate([-belt_bearing_effective_diam/2,0,0]) {
          rotate([-90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module lower_bearing_mount_base() {
    translate([line_to_motor_x-belt_bearing_effective_diam/2,mount_thickness/2,low_line_z-belt_bearing_effective_diam/2]) {
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
          hole(rod_diam+wall_thickness*3,mount_thickness,resolution);
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
        % belt_bearing();
        translate([0,-high_bearing_y+mount_thickness/2,0]) {
          bearing_base();
        }
      }
      mid_bearing_pos() {
        % belt_bearing();
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
        translate([0,0,-belt_bearing_thickness*2]) {
          hole(belt_bearing_nut_diam+wall_thickness*2,belt_bearing_nut_thickness+wall_thickness*2,resolution);
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
        % belt_bearing();
        translate([0,0,-belt_bearing_thickness/2-1]) {
          hole(belt_bearing_inner+wall_thickness,2,resolution);
        }
        translate([0,0,-belt_bearing_thickness*1.75]) {
          hole(bearing_body_diam+wall_thickness*2,2,resolution);
        }
      }

      lower_bearing_mount_base();
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
  }

  module holes() {
    // side sheet screw hole
    translate([endcap_side_screw_hole_pos_x,0,endcap_side_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
      }
    }
    // top sheet screw hole
    translate([endcap_top_screw_hole_pos_x,0,endcap_top_screw_hole_pos_z]) {
      rotate([90,0,0]) {
        hole(3,50,16);
      }
    }
    line_path();
    high_bearing_pos() {
      // bolt
      hole(3,belt_bearing_thickness*8,8);
      hole(belt_bearing_diam+spacer,belt_bearing_thickness+belt_bearing_washer_thickness*2,resolution);
      translate([0,50,0]) {
        cube([belt_bearing_diam+spacer,100,belt_bearing_thickness+belt_bearing_washer_thickness*2],center=true);
      }
      // captive nut
      translate([0,0,-belt_bearing_thickness*2-belt_bearing_nut_thickness/2]) {
        hole(belt_bearing_nut_diam,belt_bearing_nut_thickness,6);
        translate([0,-25,0]) {
          cube([belt_bearing_nut_diam,50,belt_bearing_nut_thickness],center=true);
        }
      }
    }
    mid_bearing_pos() {
      hole(3,60,8);
      translate([0,0,-bearing_body_thickness/2]) {
        // captive nut
        rotate([0,0,90]) {
          hole(belt_bearing_nut_diam,belt_bearing_nut_thickness,6);
        }
      }
      cube([belt_bearing_diam+spacer*4,belt_bearing_diam+spacer,belt_bearing_thickness+belt_bearing_washer_thickness*2],center=true);
    }
    low_bearing_pos() {
      translate([0,0,20]) {
        hole(belt_bearing_diam+spacer*2,belt_bearing_thickness+belt_bearing_washer_thickness*2+40,resolution);
      }
      hole(3,60,resolution);
      translate([0,0,-low_bearing_y]) {
        hole(belt_bearing_nut_diam,belt_bearing_nut_thickness*2,6);
      }
    }

    // y rod
    rotate([90,0,0]) {
      % hole(rod_diam,mount_thickness*2+1,16);
    }
  }

  module bridges() {
    difference() {
      high_bearing_pos() {
        belt_bearing_bevel();
      }
      line_path();
    }
    mid_bearing_pos() {
      belt_bearing_bevel();
    }
    low_bearing_pos() {
      belt_bearing_bevel([front]);
    }
  }

  % low_bearing_pos() {
    rotate([0,0,high_to_low_line_angle_y]) {
      translate([-xy_line_x,belt_bearing_effective_diam/2,0]) {
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

module assembly() {
  translate([0,y_pos,0]) {
    for(side=[left,right]) {
      mirror([1+side,0,0]) {
        translate([-y_rod_x,0,0]) {
          y_carriage();
        }
      }
    }

    // x rods
    % for (side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          rotate([0,0,22.5/2]) {
            cylinder(r=rod_diam/2,h=x_rod_len,center=true,$fn=16);
          }
        }
      }
    }

    translate([x_pos,0,0]) {
      x_carriage();
    }
  }

  z_axis_stationary();

  translate([0,sheet_pos_y*front,sheet_pos_z]) {
    rotate([90,0,0]) {
      color("lightblue", sheet_opacity) {
        front_sheet();
      }
    }
  }

  translate([0,0,top_sheet_pos_z]) {
    color("violet", sheet_opacity) {
      top_sheet();
    }
  }

  translate([0,0,bottom_sheet_pos_z]) {
    color("yellowgreen", sheet_opacity) {
      bottom_sheet();
    }
  }

  translate([0,sheet_pos_y*rear,sheet_pos_z]) {
    color("lightgreen", sheet_opacity) {
      rotate([90,0,0]) {
        rear_sheet();
      }
    }
  }

  for(side=[left,right]) {
    translate([side_sheet_pos_x*side,side_sheet_pos_y,side_sheet_pos_z]) {
      rotate([0,90*side,0]) {
        rotate([0,0,90*side]) {
          color("khaki", sheet_opacity) {
            side_sheet();
          }
        }
      }
    }
  }

  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([y_rod_x,sheet_pos_y+sheet_thickness/2,0]) {
        rear_xy_endcap();
      }
      translate([y_rod_x,front*(sheet_pos_y+sheet_thickness/2),0]) {
        front_xy_endcap();
      }
    }
  }

  // xy motors
  // inside
  /*
  for(side=[left,right]) {
    //translate([(side_sheet_pos_x-sheet_thickness/2-motor_side/2)*side,sheet_pos_y-sheet_thickness/2,top_sheet_pos_z-sheet_thickness/2-motor_side/2-5]) {
    translate([(side_sheet_pos_x-sheet_thickness/2-motor_side/2)*side,sheet_pos_y-sheet_thickness/2,bottom_sheet_pos_z+sheet_thickness/2+motor_side/2]) {
      rotate([-90,0,0]) {
        % motor();
      }
    }
  }
  */
  // on the back
  for(side=[left,right]) {
    translate([(y_carriage_belt_bearing_x+belt_bearing_effective_diam/2-motor_shaft_len*.6)*side,sheet_pos_y+sheet_thickness/2+motor_side/2,bottom_sheet_pos_z+sheet_thickness/2+motor_side/2]) {
      rotate([0,90*side,0]) {
        % motor();

        translate([0,0,2+motor_shaft_len/2]) {
          % hole(pulley_diam,motor_shaft_len-4,resolution);
        }
      }
    }
  }
  /*
  */

  // handle!
  // shouldn't put the handle here, because it's probably going to interfere with the bowden tube.
  translate([0,sheet_pos_y*rear-sheet_thickness,top_of_sheet]) {
    color("blue", sheet_opacity) {
      rotate([90,0,0]) {
        //handle();
      }
    }
  }
}

module z_axis_stationary() {
  z_belt_bearing_diam = 10;
  z_belt_pulley_diam  = 10;
  motor_pos_z         = top_sheet_pos_z-sheet_thickness/2-motor_side/2;
  motor_pos_z         = bottom_sheet_pos_z+sheet_thickness/2+motor_side/2;

  // z rods
  for (side=[left,right]) {
    translate([z_rod_pos_x*side,z_rod_pos_y,z_rod_pos_z]) {
      % cylinder(r=z_rod_diam/2,h=z_rod_len+0.1,center=true);
    }
  }

  translate([z_motor_pos_x,z_motor_pos_y,z_motor_pos_z]) {
    rotate([90,0,0]) {
      % motor();
    }
  }
  translate([z_motor_pos_x,z_rod_pos_y,z_motor_pos_z]) {
    rotate([90,0,0]) {
      % difference() {
        hole(z_pulley_diam,z_belt_bearing_thickness,resolution);
        hole(6,z_belt_bearing_thickness+1,resolution);
      }
    }
  }

  translate([z_motor_pos_x,z_rod_pos_y,z_idler_pos_z]) {
    rotate([90,0,0]) {
      % difference() {
        hole(z_pulley_diam,z_belt_bearing_thickness,resolution);
        hole(6,z_belt_bearing_thickness+1,resolution);
      }
    }
  }
}

module z_axis() {
  build_base_z = build_pos_z-build_z/2-heatbed_and_glass_thickness-sheet_thickness/2;
  //build_base_z = z_rod_pos_z;
  z_bearing_bed_offset = z_bearing_len/2*bottom + sheet_thickness*0;

  module z_build_plate() {
    cube([build_x+14,build_y+14,2],center=true);
  }

  // z bearings
  for(side=[left,right]) {
    translate([z_rod_pos_x*side,z_rod_pos_y,build_base_z+z_bearing_bed_offset]) {
      % hole(z_bearing_diam,z_bearing_len,16);
    }
  }

  // z belt bearings
  for(side=[top,bottom]) {
    translate([0,z_rod_pos_y,build_base_z+z_bearing_bed_offset+(z_belt_bearing_diam/2+belt_thickness*2+1)*side]) {
      rotate([90,0,0]) {
        difference() {
          hole(z_belt_bearing_diam,z_belt_bearing_thickness,16);
          hole(z_belt_bearing_inner,z_belt_bearing_thickness+1,16);
        }
      }
    }
  }

  translate([0,build_pos_y,build_base_z+sheet_thickness/2 + 3 + build_z/2]) {
    //% cube([build_x,build_y,build_z],center=true);
  }

  translate([build_pos_x,build_pos_y,build_base_z]) {
    translate([0,0,sheet_thickness/2+1]) {
      color("red") {
        z_build_plate();
      }
    }

    cube([build_x+20,build_y+20,sheet_thickness],center=true);
  }

  z_belt_bearing_diam = 10;
  z_belt_pulley_diam  = 10;
  motor_pos_z         = top_sheet_pos_z-sheet_thickness/2-motor_side/2;
  motor_pos_z         = bottom_sheet_pos_z+sheet_thickness/2+motor_side/2;
}

translate([0,0,build_z*1-z_pos]) {
  z_axis();
}

assembly();
