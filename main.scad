da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

zip_tie_width = 3;
zip_tie_thickness = 2;

left  = -1;
right = 1;
front = -1;
rear  = 1;

build_x = 600;
build_y = 600;
build_z = 600;

build_x = 200;
build_y = 200;
build_z = 200;

build_x = 150;
build_y = 150;
build_z = 150;

// lm10uu, M10 rods
lm10uu_bearing_diam = 19;
lm10uu_bearing_len  = 29;
lm10uu_rod_diam = 10;

// lm8uu, M8 rods
lm8uu_bearing_diam = 15;
lm8uu_bearing_len  = 24;
lm8uu_rod_diam = 8;

// lm6uu, M6 rods
lm6uu_bearing_diam = 12;
lm6uu_bearing_len  = 19;
lm6uu_rod_diam = 6;
// record bearing groove offset, depth, width

bearing_diam = lm10uu_bearing_diam;
bearing_diam = lm10uu_bearing_len;
rod_diam = lm10uu_rod_diam;

bearing_diam = lm8uu_bearing_diam;
bearing_diam = lm8uu_bearing_len;
rod_diam = lm8uu_rod_diam;

bearing_diam = lm6uu_bearing_diam;
bearing_len = lm6uu_bearing_len;
rod_diam = lm6uu_rod_diam;

belt_bearing_diam = 16;
belt_bearing_inner = 5;
belt_bearing_thickness = 5;
belt_bearing_nut_diam = 8.1;
belt_bearing_nut_thickness = 5;

motor_side = 43;
motor_hole_spacing = 31;
motor_screw_diam = 3;
pulley_diam = 18;
pulley_height = belt_bearing_diam + 8;
min_material_thickness = 2;

sheet_thickness = 6;
sheet_min_width = 30;
spacer = 1;

y_clamp_len = 10; // amount of bar to clamp onto
x_rod_spacing = 36 + lm8uu_bearing_diam;
x_carriage_width = bearing_len * 3;

clamp_screw_diam = 3;
clamp_screw_nut_diam = 5.5;
clamp_screw_nut_thickness = 3;
clamp_area_width = clamp_screw_diam+min_material_thickness*2;

top_plate_screw_diam = 3;

rod_z = belt_bearing_diam/2 + belt_bearing_thickness/2 + min_material_thickness*2;

// X rods
x_rod_clamp_len = bearing_len*2 + spacer + min_material_thickness*2;
x_rod_len = build_x + x_carriage_width + belt_bearing_diam*2 + bearing_diam;
x_rod_z = rod_z;
echo("X rod len: ", x_rod_len);

// Y rods
y_rod_len = build_y + x_rod_spacing + rod_diam + min_material_thickness*2 + y_clamp_len*2 + spacer*2;
y_rod_x = x_rod_len/2 + bearing_diam/2 + min_material_thickness;
y_rod_z_distance_to_x = 0;
y_rod_z = rod_z + y_rod_z_distance_to_x;
echo("Y rod len: ", y_rod_len);


xy_idler_x = y_rod_x - bearing_diam/2 - belt_bearing_diam/2 - min_material_thickness;
xy_idler_y = belt_bearing_diam/2 + belt_bearing_inner/2;
xy_idler_y = x_rod_spacing/2+bearing_diam-22;
xy_idler_y = x_rod_spacing/2-rod_diam/2-belt_bearing_inner/2-min_material_thickness/2;
xy_idler_z = x_rod_z + belt_bearing_diam/2;
xy_idler_z = x_rod_z + rod_diam/2 + min_material_thickness + belt_bearing_thickness/2 + spacer;

front_idler_x = xy_idler_x + belt_bearing_diam/2;
front_idler_y = -y_rod_len/2 - belt_bearing_inner/2 - min_material_thickness/2;
front_idler_z = xy_idler_z - belt_bearing_diam/2;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
lower_rear_idler_y = y_rod_len/2 - y_clamp_len + belt_bearing_diam/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
upper_rear_idler_y = lower_rear_idler_y;
upper_rear_idler_z = xy_idler_z;

avoid_crossing = 10;
xy_motor_x = motor_side/2 + spacer;
xy_motor_y = y_rod_len/2 + motor_side/2 + sheet_thickness/2 + spacer;
xy_motor_z = -sheet_thickness;

module motor() {
  difference() {
    translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  cylinder(r=5/2,h=motor_side,center=true);
}

module motor_with_pulley() {
  motor();
  translate([0,0,sheet_thickness+spacer+pulley_height/2]) cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing() {
  rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
    rotate([0,0,22.5]) cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true);
  }
}

// x carriage
module x_carriage() {
  carriage_thickness = bearing_diam/2-rod_diam/2+min_material_thickness;
  carriage_depth = x_rod_spacing+bearing_diam+min_material_thickness*2;
  carriage_bottom_z = rod_diam/2;

  extruder_mount_hole_distance = 50;
  extruder_mount_screw_diam = 4;
  hotend_hole_diam = extruder_mount_hole_distance - extruder_mount_screw_diam*2 - min_material_thickness*2;

  tension_line_y = xy_idler_y-belt_bearing_diam/2;
  tension_screw_diam = 4;
  tension_screw_nut_diam = 7;
  tension_screw_nut_thickness = 2;
  tension_screw_x = x_carriage_width/2-tension_screw_nut_diam/2-min_material_thickness;
  tension_screw_y = tension_line_y+tension_screw_diam/2;
  tension_screw_z = carriage_thickness/2;
  tension_screw_post_diam = tension_screw_nut_diam+min_material_thickness;
  tension_screw_post_height = 10;

  tuning_peg_len = 22;

  module x_carriage_base() {
    // main body
    //translate([0,0,bearing_diam/2+min_material_thickness/2])
    translate([0,0,carriage_bottom_z+carriage_thickness/2])
      cube([x_carriage_width-0.05,carriage_depth,carriage_thickness],center=true);

    // tension screw post
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([tension_screw_x*side,tension_screw_y*end,tension_screw_z]) rotate([0,0,0])
          cylinder(r=tension_screw_post_diam*da6,h=tension_screw_post_height,center=true,$fn=6);
      }

      /*
      translate([tension_screw_x*side,-tuning_peg_len,carriage_bottom_z+carriage_thickness+10]) {
        rotate([90,0,0])
          cylinder(r=6/2,h=22,center=true);
      }
      */
    }
  }

  module x_carriage_holes() {
    // bearing slots
    for(side=[front,rear]) {
      // rod clearance
      translate([0,x_rod_spacing/2*side,0]) rotate([0,90,0])
        cylinder(r=rod_diam/2+1,h=x_carriage_width+1,center=true);

      for(end=[left,right]) {
        translate([(x_carriage_width/2-bearing_len/2)*end,x_rod_spacing/2*side,0]) {
          rotate([0,0,90]) {
            # rotate([90,0,0]) difference() {
              cylinder(r=bearing_diam/2,h=bearing_len,center=true);
              cylinder(r=rod_diam/2,h=bearing_len+1,center=true);
            }
            rotate([90,0,0]) rotate_extrude()
              translate([bearing_diam/2+3,0,0])
                square([zip_tie_thickness,zip_tie_width],center=true);
          }
        }
      }
    }

    // hotend hole
    cylinder(r=hotend_hole_diam/2,h=20,center=true);
    // extruder mount holes
    for(side=[left,right]) {
      //translate([extruder_mount_hole_distance/2*side,0,0]) cylinder(r=extruder_mount_screw_diam*da8,h=20,center=true,$fn=8);
    }

    // tension screws
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([tension_screw_x*side,tension_screw_y*end,tension_screw_z]) {
          // screw shaft
          cylinder(r=tension_screw_diam*da6,h=tension_screw_post_height+1,center=true,$fn=6);

          // captive nut s
          translate([0,0,-tension_screw_post_height/2])
            cylinder(r=tension_screw_nut_diam*da6,h=tension_screw_nut_thickness*2,center=true,$fn=6);

          translate([0,0,carriage_thickness*1])
            cylinder(r=tension_screw_nut_diam*da6,h=tension_screw_nut_thickness*2,center=true,$fn=6);
        }

        // slot for line
        /*
        # translate([(x_carriage_width/2-tension_screw_diam/2)*side,(tension_line_y-.95)*end,carriage_thickness*1.5])
          cube([(x_carriage_width/2-tension_screw_x)*2,2,5],center=true);
        */
      }
    }
  }

  // fan
  //translate([x_carriage_width/2,0,-15]) cube([5,40,40],center=true);

  difference() {
    x_carriage_base();
    x_carriage_holes();
  }
}

// y carriage
y_carriage_len = x_rod_spacing + rod_diam + min_material_thickness*2;
y_bar_to_x_clamp_end = y_rod_x - xy_idler_x + belt_bearing_inner/2 + min_material_thickness*2;
module y_carriage() {
  line_x = y_rod_x-xy_idler_x-belt_bearing_diam/2;
  idler_x = line_x+belt_bearing_diam/2;
  idler_z = xy_idler_z - y_rod_z;

  x_clamp_width = rod_diam + min_material_thickness * 2;
  y_clamp_width = bearing_diam + min_material_thickness*2;

  module y_carriage_body() {
    // bearing clamp
    rotate([90,0,0]) {
      rotate([0,0,22.5])
      cylinder(r=y_clamp_width*da8,h=y_carriage_len,center=true,$fn=8);
    }

    for(side=[0,1]) {
      mirror([0,side,0]) {
        hull() {
          // x rod clamp
          translate([0,x_rod_spacing/2,0]) {
            translate([y_bar_to_x_clamp_end/2,0,0]) {
              rotate([0,90,0])
                cylinder(r=x_clamp_width/2,h=y_bar_to_x_clamp_end,center=true);

              // anchor to print bed
              translate([0,min_material_thickness,-y_clamp_width/4])
                cube([y_bar_to_x_clamp_end,rod_diam,y_clamp_width/2],center=true);
            }
          }

          // idler bearing support top
          translate([idler_x,xy_idler_y,(idler_z-belt_bearing_thickness/2)/2])
            cylinder(r=(belt_bearing_inner+min_material_thickness*2)/2,h=idler_z-belt_bearing_thickness/2,center=true);

          // idler bearing support bottom
          translate([idler_x,xy_idler_y,-y_clamp_width/2+min_material_thickness/2])
            cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=min_material_thickness,center=true);

          // anchor to y clamp
          translate([0,xy_idler_y,-y_clamp_width/2+min_material_thickness/2])
            cube([rod_diam,belt_bearing_inner+min_material_thickness*2,min_material_thickness],center=true);
        }
      }
    }
  }

  bearing_y = y_carriage_len/2-bearing_len/2-min_material_thickness;
  module y_carriage_holes() {
    for(side=[front,rear]) {
      translate([0,bearing_y*side,0]) {
        // y bearing hole and access
        rotate([0,45,0]) {
          translate([-bearing_diam/2,0,0])
            cube([bearing_diam,bearing_len,bearing_diam],center=true);
            # bearing();
        }

        // zip tie groove
        rotate([90,0,0]) rotate_extrude()
          translate([bearing_diam/2+3.1,0,0])
            square([zip_tie_thickness,zip_tie_width],center=true);
      }

      // idler bearing holes
      translate([idler_x,xy_idler_y*side,0]) rotate([0,0,22.5])
        cylinder(r=belt_bearing_inner*da8,h=y_clamp_width+1,center=true,$fn=8);
    }

    // extreme material trim
    translate([-y_clamp_width/2,0,0]) cube([y_clamp_width,y_carriage_len+1,y_clamp_width+1],center=true);

    rotate([0,45,0]) {
      // material trim
      translate([-y_clamp_width/2-rod_diam+1,0,0]) {
        cube([y_clamp_width+0.5,y_carriage_len+1,y_clamp_width+0.5],center=true);
      }
      translate([-y_clamp_width*.7,0,0]) {
        rotate([0,45,0]) cube([y_clamp_width,y_carriage_len+1,y_clamp_width],center=true);
      }

      // y rod holes
      translate([-rod_diam/2,0,0])
        cube([rod_diam+1,y_carriage_len+1,rod_diam+1],center=true);
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=(rod_diam+1)*da8,h=y_carriage_len+1,center=true,$fn=8);
    }

    // x rod holes
    for(side=[front,rear]) {
      translate([y_rod_x,x_rod_spacing/2*side,0]) rotate([0,90,0]) rotate([0,0,22.5])
        cylinder(r=rod_diam*da8,h=x_rod_len+2,center=true,$fn=8);

    }

    // x rod clamp

    /*
    clamp_screw_x = idler_x-belt_bearing_inner/2-spacer/2-clamp_screw_diam/2;
    clamp_screw_z = -rod_diam/2-clamp_screw_diam/2-spacer/2;
    for(side=[0,1]) {
      mirror([0,side,0]) {
        translate([clamp_screw_x,x_rod_spacing/2,clamp_screw_z]) {
          rotate([90,0,0]) rotate([0,0,22.5])
            cylinder(r=clamp_screw_diam*da8,h=30,center=true,$fn=8);
        }
      }
    }
    */

    // line clearance
    translate([line_x,0,idler_z-belt_bearing_diam])
      rotate([90,0,0]) cylinder(r=4*da6,h=y_carriage_len+1,center=true,$fn=6);
  }

  difference() {
    y_carriage_body();
    y_carriage_holes();
  }
}

module rod_clamp(rod_diam) {
  rod_clamp_width = clamp_area_width;
  rod_clamp_diam = rod_diam+min_material_thickness*2;
  clamp_screw_plate_width = clamp_screw_nut_diam + min_material_thickness*3;

  module rod_clamp_body() {
    hull() {
      rotate([0,0,22.5])
        cylinder(r=rod_clamp_diam/2,h=rod_clamp_width,center=true);

      translate([rod_clamp_diam/2,0,0])
        cube([clamp_screw_plate_width,rod_clamp_diam,rod_clamp_width],center=true);
    }
  }

  module rod_clamp_holes() {
    // rod hole
    rotate([0,0,22.5])
      cylinder(r=rod_diam*da8,h=rod_clamp_width+1,center=true,$fn=8);

    translate([rod_diam/2+clamp_screw_diam/2+min_material_thickness,0,0]) {
      // screw hole
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=clamp_screw_diam*da8,h=rod_clamp_diam+1,center=true,$fn=8);

      // captive nut
      translate([0,-rod_clamp_diam/2,0]) rotate([90,0,0])
        cylinder(r=clamp_screw_nut_diam*da6,h=clamp_screw_nut_thickness,center=true,$fn=6);

      // clamp gap
      cube([clamp_screw_plate_width+1,spacer,rod_clamp_width+1],center=true);
    }

  }

  translate([0,0,0]) difference() {
    rod_clamp_body();
    rod_clamp_holes();
  }
}

module old_y_carriage() {
  bearing_clamp_width = bearing_diam+min_material_thickness*2;
  module y_carriage_body() {
    // y bearing clamp
    rotate([90,0,0]) rotate([0,0,22.5])
      cylinder(r=da8*bearing_clamp_width,h=y_carriage_len,center=true,$fn=8);


    // x rod clamp
    x_clamp_len = bearing_clamp_width/2 + spacer + belt_bearing_diam/2 + belt_bearing_inner/2 + min_material_thickness;
    x_clamp_width = (x_rod_spacing/2 - xy_idler_y) + rod_diam/2 + min_material_thickness*2 + belt_bearing_inner/2;
    x_clamp_thickness = rod_diam/2 + min_material_thickness + bearing_diam/2 + min_material_thickness;
    x_clamp_pos_z = (bearing_clamp_width - x_clamp_thickness)*-0.5;
    for(side=[front,rear]) {
      translate([x_clamp_len/2,(y_carriage_len/2 - x_clamp_width + x_clamp_width/2)*side,x_clamp_pos_z])
        cube([x_clamp_len,x_clamp_width,x_clamp_thickness],center=true);
    }
  }

  module y_carriage_holes() {
    bearing_y = y_carriage_len/2-bearing_len/2-min_material_thickness;

    // bearing holes
    rotate([0,45,0]) {
      // material trim
      translate([-bearing_clamp_width/2-rod_diam+1,0,0]) {
        cube([bearing_clamp_width+0.5,y_carriage_len+1,bearing_clamp_width+0.5],center=true);
      }
      translate([-bearing_clamp_width*.7,0,0]) {
        rotate([0,45,0]) cube([bearing_clamp_width,y_carriage_len+1,bearing_clamp_width],center=true);
      }

      // bearing holes
      for(side=[front,rear]) {
        translate([0,bearing_y*side,0]) {
          translate([-bearing_diam/2,0,0])
            cube([bearing_diam,bearing_len,bearing_diam],center=true);
          # bearing();
        }
      }

      // y rod holes
      translate([-rod_diam/2,0,0])
        cube([rod_diam+1,y_carriage_len+1,rod_diam+1],center=true);
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=(rod_diam+1)*da8,h=y_carriage_len+1,center=true,$fn=8);
    }

    // x rod holes
    len = 40;
    for(side=[front,rear]) {
      translate([len/2+bearing_diam/2+min_material_thickness,x_rod_spacing/2*side,-y_rod_z_distance_to_x])
        rotate([0,90,0]) rotate([0,0,22.5])
          cylinder(r=rod_diam*da8,h=len,center=true,$fn=8);
    }

    // idler holes
    idler_x = y_rod_x - xy_idler_x;
    idler_y = xy_idler_y;
    for(side=[front,rear]) {
      translate([idler_x,idler_y*side,0]) cylinder(r=da6*belt_bearing_inner,h=bearing_diam*2,center=true,$fn=6);
    }
  }

  difference() {
    y_carriage_body();
    y_carriage_holes();
  }
}

screw_pad_height = min_material_thickness*2;
screw_pad_outer_diam = top_plate_screw_diam+min_material_thickness*2;

module y_end_rear() {
  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness;
  clamp_gap_width = spacer;

  rod_end_dist_to_lower_idler_x = y_rod_x - lower_rear_idler_x;
  rod_end_dist_to_lower_idler_y = lower_rear_idler_y - rear*y_rod_len/2;
  rod_end_dist_to_lower_idler_z = lower_rear_idler_z - y_rod_z;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  idler_support_thickness = belt_bearing_diam-belt_bearing_thickness-spacer*2;

  bearing_screw_pos = [rod_end_dist_to_lower_idler_x,rod_end_dist_to_lower_idler_y,0];
  inside_screw_pos = [rod_end_dist_to_lower_idler_x+belt_bearing_diam/2+screw_pad_outer_diam/2+spacer,-clamp_len+screw_pad_outer_diam/2,0];
  outside_screw_pos = [-clamp_width,0,0];
  rod_end_screw_pos = [0,clamp_len+screw_pad_outer_diam/2,0];

  module y_end_rear_body() {
    // rod hole body
    hull() {
      translate([0,-clamp_len/2,0]) {
        rotate([90,0,0]) rotate([0,0,22.5])
          cylinder(r=clamp_width/2,h=clamp_len,center=true);

        // main tower
        translate([0,0,-y_rod_z+screw_pad_height/2]) {
          translate([0,clamp_len*.5,0])
            cube([clamp_width,clamp_len,screw_pad_height],center=true);

          translate([0,-clamp_len/2+clamp_width/2,0])
            rotate([0,0,22.5]) cylinder(r=da8*clamp_width,h=screw_pad_height,center=true,$fn=8);
        }

        // clamp body
        translate([0,0,clamp_screw_body_height/2+rod_diam/2]) {
          cube([rod_diam,clamp_len,clamp_screw_body_height],center=true);

          translate([-clamp_width/4,0,0]) rotate([0,90,0])
            cylinder(r=clamp_screw_nut_diam*da8,h=clamp_width/2,center=true,$fn=8);
        }
      }
    }

    // screw pad
    translate([0,0,-y_rod_z+screw_pad_height/2]) {
      hull() {
        for(vector=[outside_screw_pos,rod_end_screw_pos]) {
          translate(vector) rotate([0,0,22.5])
            cylinder(r=da8*screw_pad_outer_diam,h=screw_pad_height,center=true,$fn=8);
        }
        translate([0,-clamp_len/2,0]) cube([clamp_width,clamp_len,screw_pad_height],center=true);
      }
    }

    translate([0,0,-y_rod_z/2+idler_support_thickness/4]) {
      translate(inside_screw_pos) rotate([0,0,22.5])
        cylinder(r=screw_pad_outer_diam*da8,h=y_rod_z+idler_support_thickness/2,center=true,$fn=8);
    }

    // idler support
    hull() translate([0,0,rod_end_dist_to_idler_z]) {
      // main bearing support
      translate(bearing_screw_pos) {
        cylinder(r=belt_bearing_inner/2+min_material_thickness*1,h=idler_support_thickness+spacer*2,center=true);
      }

      // inside support post
      translate(inside_screw_pos) rotate([0,0,22.5])
        cylinder(r=screw_pad_outer_diam*da8,h=idler_support_thickness/2,center=true,$fn=8);

      // anchor to bar clamp
      translate([0,-clamp_len/2,0])
        rotate([90,0,0]) cylinder(r=belt_bearing_inner/2+min_material_thickness,h=clamp_len,center=true);
    }
  }

  module y_end_rear_holes() {
    translate([0,-clamp_len/2,0]) {
      // y rod hole
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=da8*rod_diam,h=50,center=true,$fn=8);

      translate([0,0,clamp_screw_body_height/2+rod_diam/2]) {
        // clamp slot
        cube([clamp_gap_width,clamp_len*2,clamp_screw_body_height+1],center=true);

        // clamp screw
        rotate([0,90,0]) rotate([0,0,22.5])
          cylinder(r=clamp_screw_diam*da8,h=clamp_width+3,center=true,$fn=8);

        // clamp screw captive nut
        translate([clamp_gap_width/2+min_material_thickness+clamp_screw_nut_thickness,0,0]) rotate([0,90,0])
          cylinder(r=clamp_screw_nut_diam*da6,h=5,center=true,$fn=6);
      }

    }

    translate(bearing_screw_pos) rotate([0,0,22.5])
      cylinder(r=belt_bearing_inner*da8,h=y_rod_z*2,center=true,$fn=8);

    for(vector=[inside_screw_pos,outside_screw_pos,rod_end_screw_pos])
    translate(vector) {
      rotate([0,0,22.5]) {
        cylinder(r=da8*top_plate_screw_diam,h=y_rod_z*2+1,center=true,$fn=8);
        translate([0,0,5])
          cylinder(r=da8*top_plate_screw_diam*1.5,h=5,center=true,$fn=8);
      }
    }

    // clamp slot
    // clamp screw
    // clamp captive nut
  }

  difference() {
    y_end_rear_body();
    y_end_rear_holes();
  }
}

module y_end_front() {
  // top plate screw area
  screw_pad_len = y_clamp_len*1.5;
  screw_pad_width = y_clamp_len;

  rod_end_dist_to_idler_x = front_idler_x - y_rod_x;
  rod_end_dist_to_idler_y = front_idler_y - front*y_rod_len/2;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;

  outside_screw_pos = [-clamp_width,0,0];
  rod_end_screw_pos = [0,rod_end_dist_to_idler_y-belt_bearing_diam/2,0];
  inside_screw_pos = [clamp_width/2+top_plate_screw_diam+spacer,clamp_len-screw_pad_outer_diam/2,0];

  module y_end_front_body() {
    bearing_support_len = rod_end_dist_to_idler_x*left-belt_bearing_thickness/2+rod_diam/2+min_material_thickness;

    // y clamp area
    hull() {
      translate([0,clamp_len/2-(clamp_len-y_clamp_len),0]) {
        // rod hole body
        translate([0,0,-y_rod_z/2])
          cube([clamp_width,clamp_len,y_rod_z],center=true);
        rotate([90,0,0])
          cylinder(r=clamp_width/2,h=clamp_len,center=true);
      }
      translate([(bearing_support_len-clamp_width)/2-spacer,rod_end_dist_to_idler_y,rod_end_dist_to_idler_z]) {
        rotate([0,90,0]) rotate([0,0,22.5])
          cylinder(r=(belt_bearing_nut_diam+min_material_thickness*2)/2,h=bearing_support_len,center=true);
        translate([spacer/2,0,0]) rotate([0,90,0]) rotate([0,0,22.5])
          # cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=bearing_support_len+spacer,center=true,$fn=8);
      }
    }

    // screw pad
    hull() {
      translate([0,0,-y_rod_z+screw_pad_height/2]) {
        translate(outside_screw_pos) rotate([0,0,22.5])
          cylinder(r=screw_pad_outer_diam*da8,h=screw_pad_height,center=true,$fn=8);

        for(vector=[rod_end_screw_pos,inside_screw_pos]) {
          translate(vector) rotate([0,0,22.5])
            cylinder(r=screw_pad_outer_diam*da8,h=screw_pad_height,center=true,$fn=8);
        }
        translate([0,clamp_len/2,0])
          cube([clamp_width,clamp_len,screw_pad_height],center=true);
      }
    }
  }

  module y_end_front_holes() {
    translate([0,y_clamp_len/2+0.5,0]) {
      // y rod hole
      rotate([90,0,0]) cylinder(r=da8*rod_diam,h=y_clamp_len+1,center=true,$fn=8);
    }

    // idler slot
    translate([0,rod_end_dist_to_idler_y,rod_end_dist_to_idler_z]) {
      // idler screw hole
      rotate([0,90,0]) rotate([0,0,22.5])
        cylinder(r=da8*belt_bearing_inner,h=40,center=true,$fn=8);

      // idler screw captive nut
      translate([-clamp_width/2-belt_bearing_nut_diam/4,0,0]) rotate([0,90,0])
        cylinder(r=da6*belt_bearing_nut_diam,h=belt_bearing_nut_thickness,center=true,$fn=6);
    }

    translate([0,0,-y_rod_z+screw_pad_height/2]) {
      for(coord=[outside_screw_pos,rod_end_screw_pos,inside_screw_pos]) {
        translate(coord) rotate([0,0,22.5])
          cylinder(r=top_plate_screw_diam*da8,h=screw_pad_height+1,center=true,$fn=8);
      }
    }
  }

  difference() {
    y_end_front_body();
    y_end_front_holes();
  }
}

module idlers() {

  // carriage anchor front
  translate([xy_idler_x*left,xy_idler_y*front,xy_idler_z]) idler_bearing();

  // front idler
  translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();

  // lower rear idler
  translate([lower_rear_idler_x*left,lower_rear_idler_y,lower_rear_idler_z]) idler_bearing();

  // upper rear idler
  translate([upper_rear_idler_x*right,upper_rear_idler_y,upper_rear_idler_z]) idler_bearing();

  // carriage anchor rear
  translate([xy_idler_x*right,xy_idler_y*rear,xy_idler_z]) idler_bearing();

  // motor
  translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) motor_with_pulley();
}

module line() {
  x_most = (xy_idler_x + belt_bearing_diam/2);
  front = -1;
  rear = 1;
  left = -1;
  right = 1;

  carriage_x = x_carriage_width/2;
  carriage_y = xy_idler_y-belt_bearing_diam/2;
  line_diam = .5;
  line_cube = [line_diam,line_diam,line_diam];

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

  // front idler to lower rear
  hull() {
    translate([x_most*left,lower_rear_idler_y,lower_rear_idler_z]) cube(line_cube,center=true);
    translate([x_most*left,front_idler_y,lower_rear_idler_z]) cube(line_cube,center=true);
  }

  // lower rear to pulley
  hull() {
    translate([lower_rear_idler_x*left,lower_rear_idler_y+belt_bearing_diam/2,lower_rear_idler_z]) cube(line_cube,center=true);
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,lower_rear_idler_z]) cube(line_cube,center=true);
  }

  // pulley to upper rear
  hull() {
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([upper_rear_idler_x*right,upper_rear_idler_y+belt_bearing_diam/2,upper_rear_idler_z]) cube(line_cube,center=true);
  }

  // upper rear to y carriage rear
  hull() {
    translate([x_most*right,upper_rear_idler_y,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([x_most*right,xy_idler_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
  }

  // y carriage rear to x carriage rear
  hull() {
    translate([xy_idler_x*right,carriage_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
    translate([carriage_x*right,carriage_y*rear,upper_rear_idler_z]) cube(line_cube,center=true);
  }
}
