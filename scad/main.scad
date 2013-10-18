include <config.scad>;
include <positions.scad>;
use <util.scad>;

//echo("x rod len: ",x_rod_len);
//echo("y rod len: ",y_rod_len);

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

module nema14() {
  difference() {
    translate([0,0,-nema14_side/2]) cube([nema14_side,nema14_side,nema14_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema14_hole_spacing/2*side,nema14_hole_spacing/2*end,0]) cylinder(r=nema14_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,nema14_shaft_len/2]) cylinder(r=nema14_shaft_diam/2,h=nema14_shaft_len,center=true);
}

module motor_with_pulley() {
  motor();
  pulley_z_above_motor_base = xy_pulley_above_motor_plate+pulley_height/2;
  translate([0,0,pulley_z_above_motor_base])
    cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing_zip_tie() {
  rotate([90,0,0])
    rotate_extrude()
      translate([bearing_diam/2+3,0,0])
        square([zip_tie_thickness,zip_tie_width],center=true);
}

module bearing() {
  rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module bearing_cavity() {
  rotate([90,0,0])
    difference() {
      // main body
      cylinder(r=bearing_diam/2+0.05,h=bearing_len+0.05,center=true);

      // grooves
      for(side=[left,right]) {
        translate([0,0,bearing_groove_spacing/2*side])
          rotate_extrude()
            //translate([bearing_diam/2,0,0]) rotate([0,0])
            //  square([bearing_groove_depth*2,bearing_groove_width],center=true);
            translate([bearing_diam/2,0,0]) /* resize([1,1]) */ rotate([0,0,45])
              square([bearing_groove_width,bearing_groove_width],center=true);
      }
    }
}

module bearing_with_zip_tie() {
  bearing_cavity();
  bearing_zip_tie();
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2+belt_bearing_groove_depth,h=belt_bearing_thickness,center=true,$fn=12);
    rotate([0,0,22.5])
      cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true,$fn=8);
  }
}

// x carriage
x_carriage_thickness = rod_diam;
x_carriage_thickness = bearing_diam*0.7;
x_carriage_thickness = xy_idler_z-x_rod_z;
module x_carriage() {
  line_y = xy_idler_y-belt_bearing_diam/2;
  line_z = xy_idler_z-x_rod_z;

  bearing_x = x_carriage_width/2-bearing_len/2-min_material_thickness;
  carriage_depth = x_rod_spacing-rod_diam-spacer*2;
  carriage_depth = x_rod_spacing+bearing_diam + min_material_thickness;
  carriage_z = rod_diam/2+x_carriage_thickness/2;
  carriage_z = 0;
  carriage_z = rod_diam*0.7;
  carriage_z = line_z-x_carriage_thickness/2;

  hole_width = x_carriage_width - min_material_thickness*6;
  hole_depth = x_rod_spacing - bearing_diam - min_material_thickness*2;
  hole_depth = x_rod_spacing - bearing_diam - min_material_thickness;

  extruder_mount_hole_spacing = 45;
  tensioner_screw_diam = 4;

  module body() {
    translate([0,0,carriage_z]) cube([x_carriage_width,carriage_depth,x_carriage_thickness],center=true);
    //translate([0,0,0]) cube([x_carriage_width,x_rod_spacing-rod_diam-spacer*2,bearing_diam*.75],center=true);

    // x endstop bumper
    translate([-x_carriage_width/2+min_material_thickness,-xy_idler_y-1,-bearing_diam*0.3])
      cube([min_material_thickness*2,8,bearing_diam],center=true);
  }

  module holes() {
    for(end=[front,rear]) {
      for(side=[left,right]) {
        translate([bearing_x*side,x_rod_spacing/2*end,0]) rotate([0,0,90]) {
          bearing_cavity();
          bearing_zip_tie();

          //% bearing();
        }
      }

      // rod opening
      translate([0,x_rod_spacing/2*end,0]) rotate([0,90,0])
        cylinder(r=bearing_diam/2-1,h=x_carriage_width+1,center=true);
    }

    // main hole
    translate([0,0,carriage_z])
      cube([hole_width,hole_depth,x_carriage_thickness+1],center=true);

    // tensioner
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([(x_carriage_width/2-min_material_thickness*1.5)*side,(line_y+tensioner_screw_diam/2)*end,line_z/2]) rotate([0,0,22.5])
          cylinder(r=tensioner_screw_diam*da8,h=line_z*4,center=true,$fn=8);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

// y carriage
y_carriage_len = x_rod_spacing + rod_diam + min_material_thickness*2;
y_rod_to_x_clamp_end = y_rod_x - xy_idler_x + belt_bearing_diam/2 + belt_bearing_groove_depth*2;
y_carriage_z = bearing_diam/2+min_material_thickness;
y_carriage_bearing_y = y_carriage_len/2-bearing_len/2;
module y_carriage(endstop=1) {
  idler_x = y_rod_x - xy_idler_x;
  idler_z = xy_idler_z - y_rod_z;

  x_clamp_thickness = idler_z*2-belt_bearing_thickness-min_material_thickness;
  clamp_screw_body_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness*2;
  clamp_width = rod_diam+min_material_thickness*2;
  x_clamp_x = y_rod_to_x_clamp_end-clamp_screw_body_len/2;
  x_clamp_z = -rod_diam/2-clamp_screw_diam/2-spacer;

  idler_screw_len = idler_z-belt_bearing_thickness/2 + x_clamp_thickness/2;

  if(endstop) {
    % translate([y_rod_to_x_clamp_end-endstop_height/2,0,-x_clamp_thickness/2-endstop_width/2]) rotate([0,90,0]) rotate([0,0,90]) endstop();
  }

  module body() {
    // bearing holder
    translate([min_material_thickness*1.6,0,0])
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=da8*bearing_diam,h=y_carriage_len,center=true,$fn=8);

    translate([y_rod_to_x_clamp_end/2,0,0]) {
      // clamp space filler
      cube([y_rod_to_x_clamp_end,x_rod_spacing,x_clamp_thickness],center=true);
    }

    for(side=[front,rear]) {
      translate([idler_x,xy_idler_y*side,idler_z-belt_bearing_thickness]) {
        // idler shaft
        hull() {
          rotate([0,0,22.5]) {
            translate([0,0,.4]) cylinder(r=belt_bearing_inner*da8,h=belt_bearing_thickness,center=true,$fn=8);

            translate([0,0,-.1]) cylinder(r=belt_bearing_diam/2,h=min_material_thickness,center=true,$fn=8);
          }
        }
      }

      hull() {
        // x rod holder
        translate([y_rod_to_x_clamp_end/2,0,0]) {
          translate([0,x_rod_spacing/2*side,0]) rotate([0,90,0]) rotate([0,0,22.5])
            cylinder(r=clamp_width*da8,h=y_rod_to_x_clamp_end,center=true,$fn=8);

          // avoid overhangs on the bearing holder
          translate([0,(y_carriage_len/2-min_material_thickness/2)*side,0])
            cube([y_rod_to_x_clamp_end,min_material_thickness,bearing_diam/2],center=true);
        }
      }

      hull() {
        translate([x_clamp_x,x_rod_spacing/2*side,x_clamp_z]) {
          // x rod clamp
          cube([clamp_screw_body_len,clamp_width,clamp_screw_body_height],center=true);
        }

        translate([x_clamp_x-belt_bearing_diam/2-min_material_thickness,x_rod_spacing/2*side,0])
          cylinder(r=rod_diam/2,h=0.05,center=true);
      }
    }
  }

  module holes() {
    for(side=[front,rear]) {
      // x rod opening
      translate([y_rod_to_x_clamp_end,x_rod_spacing/2*side,0]) rotate([0,90,0]) rotate([0,0,22.5])
        cylinder(r=rod_diam*da8,h=belt_bearing_diam*2,center=true,$fn=8);

      translate([x_clamp_x,x_rod_spacing/2*side,x_clamp_z]) {
        // x clamp gap
        cube([belt_bearing_diam+min_material_thickness*2,clamp_gap_width,clamp_screw_body_height+rod_diam],center=true);

        translate([0,0,0]) {
          // clamp screw
          rotate([90,0,0]) rotate([0,0,22.5])
            cylinder(r=clamp_screw_diam*da8,h=clamp_width+3,center=true,$fn=8);

          // clamp screw captive nut
          for(end=[front,rear]) {
            translate([0,(clamp_gap_width/2+min_material_thickness+clamp_screw_nut_thickness)*-side*end,0]) rotate([90,0,0])
              cylinder(r=clamp_screw_nut_diam*da6,h=clamp_screw_nut_thickness,center=true,$fn=6);
          }
        }
      }

      translate([idler_x,xy_idler_y*side,0]) {
        // idler hole
        rotate([0,0,22.5])
          cylinder(r=belt_bearing_inner*da8,h=belt_bearing_diam,center=true,$fn=8);

        // idler clearance
        translate([0,0,idler_z]) rotate([0,0,22.5]) {
          hull() {
            translate([0,0,belt_bearing_thickness/2])
              cylinder(r=(belt_bearing_diam+belt_bearing_groove_depth*2+belt_bearing_thickness*2-2.5)*da8,h=0.1,center=true,$fn=8);
            cylinder(r=(belt_bearing_diam+belt_bearing_groove_depth*2+0.1)*da8,h=belt_bearing_thickness,center=true,$fn=8);
          }
        }

        // captive nut for idler
        translate([0,0,idler_z-10-belt_bearing_nut_thickness/2])
          cylinder(r=belt_bearing_nut_diam*da6,h=belt_bearing_nut_thickness,center=true,$fn=6);
      }

      // bearing holders
      translate([0,y_carriage_bearing_y*side,0]) {
        bearing_cavity();

        translate([0,-1*side,0])
          rotate([90,0,0]) {
            // zip tie groove
            rotate_extrude()
              translate([bearing_diam/2+3,0,0])
                square([zip_tie_thickness,zip_tie_width],center=true);
          }
      }
    }

    // bearing-side material trim
    translate([-bearing_diam+rod_diam*1.5,0,0])
      cube([bearing_diam,y_carriage_len+1,bearing_diam*2],center=true);

    // y rod opening
    rotate([90,0,0]) cylinder(r=(bearing_diam-3)/2,h=y_carriage_len+1,center=true);
  }

  difference() {
    body();
    holes();
  }
}


module y_end_rear(side=-1) {
  support_thickness = belt_bearing_thickness+min_material_thickness;
  front_sheet_clearance_height = sheet_shoulder_width;

  outer_idler_x = -1*(outer_rear_idler_x-y_rod_x);
  outer_idler_y = outer_rear_idler_y-y_rod_len/2;
  outer_idler_z = outer_rear_idler_z-y_rod_z;

  inner_idler_x = -1*(inner_rear_idler_x-y_rod_x);
  inner_idler_y = inner_rear_idler_y-y_rod_len/2+(.5*side);
  inner_idler_z = inner_rear_idler_z-y_rod_z;

  module position_inner_support() {
    difference() {
      translate([inner_idler_x,inner_idler_y,inner_idler_z]) {
        rotate([0,inner_rear_idler_angle_y,0]) {
          translate([belt_bearing_diam/2,0,-belt_bearing_thickness/2-support_thickness/2-spacer]) {
            for(i=[0:$children-1]) {
              child(i);
            }
          }
        }
      }
    }
  }

  module position_outer_support() {
    difference() {
      translate([outer_idler_x,outer_idler_y,outer_idler_z]) {
        rotate([outer_rear_idler_angle_x*side,90-outer_rear_idler_angle_y,0]) {
          translate([belt_bearing_diam/2,-belt_bearing_diam/2,belt_bearing_thickness/2+support_thickness/2+spacer]) {
            for(i=[0:$children-1]) {
              child(i);
            }
          }
        }
      }
    }
  }

  module body() {
    translate([0,-y_clamp_len+y_end_body_depth/2,-y_rod_z+y_end_body_height/2]) {
      difference() {
        cube([y_end_body_width,y_end_body_depth,y_end_body_height],center=true);

        // clearance for inner bearing
        translate([y_end_body_width/2,y_end_body_depth/2,y_end_body_height/2])
          rotate([-10,10,0])
            cube([y_end_body_depth*2,y_end_body_depth*2,5],center=true);

        // clearance for outer bearing
        translate([-y_end_body_width/2,0,y_end_body_height/2-1])
          rotate([0,-12,0])
            cube([y_end_body_depth*2,y_end_body_depth*2,5],center=true);
      }
    }

    hull() {
      // outer idler support arm
      position_outer_support() {
        translate([belt_bearing_diam*.3,-outer_idler_y+belt_bearing_diam/2-y_clamp_len+y_end_body_depth/2,spacer])
          cube([belt_bearing_diam*.6,y_end_body_depth,support_thickness],center=true);

        translate([0,0,spacer]) rotate([0,0,22.5])
          cylinder(r=belt_bearing_diam/2,h=support_thickness,center=true,$fn=8);

        translate([0,0,-spacer]) rotate([0,0,22.5])
          cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=support_thickness,center=true,$fn=8);
      }
    }

    hull() {
      translate([y_end_body_width/2,-y_clamp_len+y_end_body_depth/2,-y_rod_z+y_end_body_height*.6])
        cube([0.05,y_end_body_depth,y_end_body_height*.3],center=true);

      // inner idler support arm
      position_inner_support() {
        translate([0,0,-spacer]) rotate([0,0,22.5])
          cylinder(r=belt_bearing_diam/2,h=support_thickness,center=true,$fn=8);

        translate([0,0,spacer]) rotate([0,0,22.5])
          cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=support_thickness,center=true,$fn=8);
      }
    }
  }

  module holes() {
    // fully through rod hole
    rotate([90,0,0]) rotate([0,0,22.5]) hole(rod_diam+0.05,y_end_body_depth*2,8);

    // make screw plate sheet printable by using a removable support
    translate([0,sheet_thickness/2,-y_rod_z+front_sheet_clearance_height/2+0.2])
      cube([screw_pad_width+1,sheet_thickness,front_sheet_clearance_height-0.4],center=true);

    // outer support shaft hole
    position_outer_support() {
      translate([0,0,support_thickness-belt_bearing_nut_thickness/3])
        rotate([0,0,0]) hole(belt_bearing_nut_diam,belt_bearing_nut_thickness*1.5,6);
      rotate([0,0,22.5]) hole(belt_bearing_inner,50,8);
    }

    // inner support shaft hole
    position_inner_support() {
      translate([0,0,-support_thickness-belt_bearing_nut_thickness/2])
        rotate([0,0,0]) hole(belt_bearing_nut_diam,belt_bearing_nut_thickness*3,6);
      rotate([0,0,22.5]) hole(belt_bearing_inner,50,8);
    }

    // screw pad holes
    for(side=[left,right]) {
      translate([screw_pad_hole_spacing/2*side,-y_clamp_len/2,-y_rod_z+y_end_body_height/2]) {
        rotate([0,0,22.5])
          hole(sheet_screw_diam,y_end_body_height+1,8);
        translate([0,0,y_end_body_height/2]) hole(sheet_screw_nut_diam,sheet_screw_nut_thickness*2,6);
      }
    }

    // clear way for outer idler line
    position_outer_support()
      translate([0,0,-support_thickness/2-belt_bearing_thickness/2-spacer])
        cube([y_end_body_width*2,y_end_body_depth*2,belt_bearing_thickness],center=true);
  }

  difference() {
    body();
    holes();
  }
}

module y_end_rear_screw_holes() {
  for(side=[left,right]) {
    translate([screw_pad_hole_spacing/2*side,y_clamp_len/2,0]) hole(sheet_screw_diam,sheet_thickness+1,16);
  }
}

module y_end_front_screw_holes() {
  for(side=[left,right]) {
    translate([screw_pad_hole_spacing/2*side,y_clamp_len/2,0]) hole(sheet_screw_diam,sheet_thickness+1,16);
  }
}

module y_end_base() {
  front_sheet_clearance_height = sheet_shoulder_width;

  y_end_body_width = screw_pad_width;
  y_end_body_depth = y_clamp_len + min_material_thickness + belt_bearing_inner + min_material_thickness*2;
  y_end_body_height = y_rod_z + rod_diam/2 + min_material_thickness; //idler_clearance + rod_diam/2 + y_rod_z;

  module body() {
    translate([0,-y_rod_z+y_end_body_height/2,y_end_body_depth/2])
      cube([screw_pad_width,y_end_body_height,y_end_body_depth],center=true);
  }

  module holes() {
    // make screw plate sheet printable by using a removable support
    translate([0,-y_rod_z+front_sheet_clearance_height/2+0.2,y_clamp_len+sheet_thickness/2])
      cube([screw_pad_width+1,front_sheet_clearance_height-0.4,sheet_thickness],center=true);

    // screw pad holes
    for(side=[left,right]) {
      translate([screw_pad_hole_spacing/2*side,-y_rod_z+y_end_body_height/2,y_clamp_len/2])
        rotate([90,0,0]) {
          rotate([0,0,22.5])
            hole(sheet_screw_diam,y_end_body_height+1,8);
          translate([0,0,-y_end_body_height/2]) hole(sheet_screw_nut_diam,sheet_screw_nut_thickness*2,6);
        }
    }
  }

  translate([0,0,-y_clamp_len]) {
    difference() {
      body();
      holes();
    }
  }
}

module y_end_front(endstop=0) {
  idler_x = y_rod_x-front_idler_x;
  idler_y = front_idler_z-y_rod_z;
  idler_z = -1*(y_rod_len/2+front_idler_y)+y_clamp_len;

  module body() {
    // idler crest
    translate([0,0,-y_clamp_len]) hull() {
      translate([idler_x,idler_y-belt_bearing_thickness,idler_z]) {
        rotate([-90,0,0]) rotate([0,0,22.5]) {
          cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=belt_bearing_thickness,center=true,$fn=8);

          translate([0,0,-spacer*1.25])
            cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true,$fn=8);
        }
      }
    }

    y_end_base();
  }

  module holes() {
    // idler bolt hole
    translate([idler_x,idler_y,idler_z]) rotate([90,0,0]) rotate([0,0,22.5])
      hole(belt_bearing_inner,y_end_body_height*3,8);

    // captive bolt head, threads sticking up through idler
    translate([idler_x,-y_rod_z+sheet_shoulder_width,idler_z]) rotate([90,0,0])
      hole(belt_bearing_nut_diam,belt_bearing_nut_thickness*2,6);

    // material saving
    for(side=[left,right]) {
      translate([y_end_body_width/2*side,-y_rod_z+y_end_body_height,y_end_body_depth])
        rotate([20,0,0]) rotate([0,10*-side,0]) rotate([0,0,45*side]) {
          cube([13,20,60],center=true);
        }
    }
  }

  difference() {
    body();
    translate([0,0,-y_clamp_len]) holes();
  }
}

module idlers(side=-1) {
  debug_len = build_x*2;
  debug_len = 0;

  // carriage anchor front
  translate([xy_idler_x*right,xy_idler_y*front,xy_idler_z]) idler_bearing();

  // front idler
  //translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();
  //translate([y_rod_x*left,front_idler_y,xy_idler_z]) idler_bearing();
  //translate([(xy_idler_x+belt_bearing_diam)*left,front_idler_y,xy_idler_z]) idler_bearing();
  translate([front_idler_x*right,front_idler_y,front_idler_z]) idler_bearing();

  // inner rear idler
  translate([inner_rear_idler_x*left,inner_rear_idler_y+(.5*side),inner_rear_idler_z]) {
    rotate([0,inner_rear_idler_angle_y,0])
      translate([belt_bearing_diam/2,0,0]) {
        idler_bearing();
        translate([debug_len/2,0,0]) cube([debug_len,1,1],center=true);
      }
  }

  // outer rear idler
  translate([outer_rear_idler_x*right,outer_rear_idler_y,outer_rear_idler_z]) {
    rotate([outer_rear_idler_angle_x,90+outer_rear_idler_angle_y,])
      translate([belt_bearing_diam/2,-belt_bearing_diam/2,0]) {
        idler_bearing();
        translate([debug_len/2,0,0]) cube([debug_len,1,1],center=true);
      }
  }

  // carriage anchor rear
  translate([xy_idler_x*left,xy_idler_y*rear,xy_idler_z]) idler_bearing();

  // motor
  translate([xy_motor_x*right,xy_motor_y,xy_motor_z]) {
    rotate([-90,0,0])
      motor_with_pulley();
  }

  /*
  // pulley idler
  translate([xy_pulley_idler_x*right,xy_pulley_idler_y,front_idler_z])
    cylinder(r=pulley_idler_diam/2,h=pulley_idler_height,center=true);
    */
}

module line(side=-1) {
  x_most = (xy_idler_x + belt_bearing_diam/2);

  carriage_x = x_carriage_width/2;
  carriage_y = xy_idler_y-belt_bearing_diam/2;

  // x carriage front to y carriage front
  hull() {
    translate([carriage_x*left,carriage_y*front,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([xy_idler_x*left,carriage_y*front,upper_rear_idler_z]) cube(line_cube,center=true);
  }

  // y carriage front to front idler
  hull() {
    translate([x_most*left,xy_idler_y*front,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([x_most*left,front_idler_y,upper_rear_idler_z]) cube(line_cube,center=true);
  }

  // front idler to outer idler
  hull() {
    translate([(front_idler_x+belt_bearing_diam/2)*left,front_idler_y,front_idler_z]) cube(line_cube,center=true);
    translate([outer_rear_idler_x*left,outer_rear_idler_y,outer_rear_idler_z]) cube(line_cube,center=true);
  }

  // outer idler to pulley
  hull() {
    translate([outer_rear_idler_x*left,outer_rear_idler_y,outer_rear_idler_z]) cube(line_cube,center=true);
    translate([(xy_motor_x-pulley_diam/2)*left,xy_motor_y+xy_pulley_above_motor_plate+(.5*side),xy_motor_z]) cube(line_cube,center=true);
  }

  // pulley to inner idler
  hull() {
    translate([xy_motor_x*left,xy_motor_y+xy_pulley_above_motor_plate+pulley_height+(.5*side),xy_motor_z+pulley_diam/2]) cube(line_cube,center=true);
    translate([inner_rear_idler_x*right,inner_rear_idler_y+belt_bearing_diam/2+(.5*side),inner_rear_idler_z]) cube(line_cube,center=true);
  }

  // inner idler to y carriage rear
  hull() {
    translate([inner_rear_idler_x*right,inner_rear_idler_y+(.5*side),inner_rear_idler_z]) cube(line_cube,center=true);
    translate([(xy_idler_x+belt_bearing_diam/2)*right,xy_idler_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
  }

  // y carriage rear to x carriage rear
  hull() {
    translate([xy_idler_x*right,carriage_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([carriage_x*right,carriage_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
  }
}

module tuner() {
  hole_to_shoulder = 22.5;
  wire_hole_diam = 2;

  thin_diam = 6;
  thin_len_past_hole = 5;
  thin_len = hole_to_shoulder + thin_len_past_hole;
  thin_pos = hole_to_shoulder/2-thin_len_past_hole/2;

  shoulder_diam = 10;
  shoulder_len = 10;
  shoulder_pos = hole_to_shoulder-shoulder_len+shoulder_len/2;

  body_diam = 15;
  body_thickness = 9;
  body_square_len = 10;
  body_pos = -hole_to_shoulder-body_thickness/2;

  anchor_screw_hole_thickness = 2;
  anchor_screw_hole_diam = 2;
  anchor_screw_hole_width = 2;
  anchor_screw_hole_pos_x = body_pos+body_thickness/2-anchor_screw_hole_thickness/2;
  anchor_screw_hole_pos_y = -body_diam/2;
  anchor_screw_hole_pos_z = -body_diam/2;

  adjuster_narrow_neck_len = 2;
  adjuster_len = 24 - body_diam + adjuster_narrow_neck_len;
  adjuster_large_diam = 8;
  adjuster_thin_diam = 6;
  adjuster_x = body_pos;
  adjuster_y = body_square_len/2;
  adjuster_shaft_z = body_diam/2+adjuster_len/2;
  adjuster_paddle_z = adjuster_shaft_z + adjuster_len/2 + adjuster_paddle_len/2;
  adjuster_paddle_len = 20;
  adjuster_paddle_width = 17.8;
  adjuster_paddle_thickness = adjuster_thin_diam;

  module tuner_body() {
    //% translate([-hole_to_shoulder/2,-shoulder_diam,0]) rotate([0,90,0]) cylinder(r=thin_diam/4,h=hole_to_shoulder,center=true);

    // thin shaft
    translate([-thin_pos,0,0]) rotate([0,90,0])
      cylinder(r=thin_diam/2,h=thin_len,center=true);

    // thick shaft (area to clamp)
    translate([-shoulder_pos,0,0]) rotate([0,90,0])
      cylinder(r=shoulder_diam/2,h=shoulder_len,center=true);

    // body
    translate([body_pos,0,0]) {
      rotate([0,90,0])
        cylinder(r=body_diam/2,h=body_thickness,center=true);
      translate([0,body_square_len/2,0]) cube([body_thickness,body_square_len,body_diam],center=true);
    }

    // anchor screw hole
    translate([anchor_screw_hole_pos_x,0,0]) {
      hull() {
        translate([0,anchor_screw_hole_pos_y,anchor_screw_hole_pos_z]) rotate([0,90,0])
          cylinder(r=anchor_screw_hole_diam/2+anchor_screw_hole_width,h=anchor_screw_hole_thickness,center=true);
        rotate([0,90,0])
          cylinder(r=shoulder_diam/2,h=anchor_screw_hole_thickness,center=true);
      }
    }

    // twist adjuster
    translate([adjuster_x,adjuster_y,adjuster_shaft_z]) {
      hull() {
        translate([0,0,-adjuster_len/2-.5]) cylinder(r=adjuster_large_diam/2,h=1,center=true);
        translate([0,0,+adjuster_len/2-.5]) cylinder(r=adjuster_thin_diam/2,h=1,center=true);
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
  module tuner_holes() {
    cylinder(r=wire_hole_diam/3,h=thin_diam*2,center=true);

    translate([anchor_screw_hole_pos_x,anchor_screw_hole_pos_y,anchor_screw_hole_pos_z]) rotate([0,90,0])
      cylinder(r=anchor_screw_hole_diam/2,h=anchor_screw_hole_thickness+1,center=true);
  }

  difference() {
    tuner_body();
    tuner_holes();
  }
}

module z_carriage() {
  carriage_height = bearing_len*2 + min_material_thickness*3;
  carriage_width = motor_side/2;
  bearing_z = carriage_height/2-min_material_thickness-bearing_len/2;

  module body() {
    // bearings
    color("orange",.5) translate([0,0,0]) {
      for(side=[top,bottom]) {
        translate([0,0,-carriage_height/2+bearing_z*side]) rotate([90,0,0]) bearing();
      }
    }

    translate([-carriage_width/2,0,-carriage_height/2]) cube([motor_side/2,z_carriage_width,carriage_height],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module heatbed() {
  difference() {
    cube([heatbed_width,heatbed_depth,heatbed_thickness],center=true);
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([heatbed_hole_spacing_x/2*side,heatbed_hole_spacing_y/2*end,0])
          cylinder(r=heatbed_hole_diam/2,h=heatbed_thickness+1,center=true);
      }
    }
  }
}

module endstop() {
  cube([endstop_len,endstop_width,endstop_height],center=true);

  translate([0,0,endstop_height/2+.5]) rotate([0,5,0])
    cube([endstop_len-4,endstop_width-1,.5],center=true);
}
