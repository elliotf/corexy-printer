include <config.scad>;
include <positions.scad>;

echo("x rod len: ",x_rod_len);
echo("y rod len: ",y_rod_len);

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
  pulley_z_above_motor_base = (xy_idler_z-belt_bearing_diam/2)-xy_motor_z;
  echo("PULLEY CENTER ABOVE MOTOR_PLATE: ", pulley_z_above_motor_base);
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
              square([1,1],center=true);
      }
    }
}

module bearing_with_zip_tie() {
  bearing_cavity();
  bearing_zip_tie();
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2+belt_bearing_groove_depth,h=belt_bearing_thickness,center=true);
    rotate([0,0,22.5]) cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true);
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
  x_clamp_z = -rod_diam/2-clamp_screw_body_height/2;

  idler_screw_len = idler_z-belt_bearing_thickness/2 + x_clamp_thickness/2;
  echo("IDLER SCREW LEN: ", idler_screw_len);

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

      translate([x_clamp_x,x_rod_spacing/2*side,x_clamp_z-1]) {
        // x clamp gap
        cube([belt_bearing_diam+min_material_thickness*2,clamp_gap_width,clamp_screw_body_height+rod_diam],center=true);

        translate([0,0,0]) {
          // clamp screw
          rotate([90,0,0]) rotate([0,0,22.5])
            cylinder(r=clamp_screw_diam*da8,h=clamp_width+3,center=true,$fn=8);

          // clamp screw captive nut
          for(end=[front,rear]) {
            translate([0,(clamp_gap_width/2+min_material_thickness+clamp_screw_nut_thickness)*-side*end,0]) rotate([90,0,0])
              cylinder(r=clamp_screw_nut_diam*da6,h=5,center=true,$fn=6);
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

        // captive nut
        //translate([0,0,idler_z-idler_screw_len-belt_bearing_nut_thickness/2])
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

screw_pad_height = min_material_thickness*2;
screw_pad_outer_diam = top_plate_screw_diam+min_material_thickness*2; // FIXME: make parts fatter to make printing easier
module y_end_rear() {
  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness;

  rod_end_dist_to_lower_idler_x = y_rod_x - lower_rear_idler_x;
  rod_end_dist_to_lower_idler_y = lower_rear_idler_y - rear*y_rod_len/2;
  rod_end_dist_to_lower_idler_z = lower_rear_idler_z - y_rod_z;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  idler_support_thickness = belt_bearing_diam-belt_bearing_thickness-spacer*2;

  bearing_screw_pos = [rod_end_dist_to_lower_idler_x,rod_end_dist_to_lower_idler_y,0];
  inside_screw_pos = [rod_end_dist_to_lower_idler_x+belt_bearing_diam/2+screw_pad_outer_diam/2+spacer,-clamp_len+screw_pad_outer_diam/2,0];
  outside_screw_pos = [-clamp_width,-clamp_len+screw_pad_outer_diam/2,0];
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
          translate(vector)
            cube([screw_pad_outer_diam+min_material_thickness*1,screw_pad_outer_diam,screw_pad_height],center=true);
        }
        translate([0,-clamp_len/2,0]) cube([clamp_width,clamp_len,screw_pad_height],center=true);
      }
    }

    translate([0,0,-y_rod_z/2+idler_support_thickness/4]) {
      translate(inside_screw_pos)
        cube([screw_pad_outer_diam,screw_pad_outer_diam,y_rod_z+idler_support_thickness/2],center=true);
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

y_end_screw_hole_y = y_clamp_len-screw_pad_outer_diam/2;
module y_end_front(endstop=0) {
  // top plate screw area
  screw_pad_len = y_clamp_len*1.5;
  screw_pad_width = y_clamp_len;

  rod_end_dist_to_idler_x = front_idler_x - y_rod_x;
  rod_end_dist_to_idler_y = front_idler_y - front*y_rod_len/2;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness;

  outside_screw_pos = [-clamp_width,y_end_screw_hole_y,0];
  rod_end_screw_pos = [0,rod_end_dist_to_idler_y-belt_bearing_diam/2,0];
  inside_screw_pos = [clamp_width/2+top_plate_screw_diam+belt_bearing_thickness,y_end_screw_hole_y,0];

  endstop_holder_len = endstop_len+screw_pad_height;

  module y_end_front_body() {
    bearing_support_len = rod_end_dist_to_idler_x*left-belt_bearing_thickness/2+rod_diam/2+min_material_thickness;

    if(endstop) {
      //% translate([inside_screw_pos[0]+screw_pad_outer_diam/2+endstop_width,endstop_height/2,-3]) rotate([-90,0,0]) rotate([0,0,90]) endstop();
      % translate([y_rod_to_x_clamp_end-endstop_width/2,endstop_height/2,-2]) rotate([-90,0,0]) rotate([0,0,90])
        endstop();
    }

    // y clamp area
    hull() {
      translate([0,clamp_len/2-(clamp_len-y_clamp_len),0]) {
        // rod hole body
        translate([0,0,-y_rod_z/2])
          cube([clamp_width,clamp_len,y_rod_z],center=true);
        rotate([90,0,0]) cylinder(r=clamp_width/2,h=clamp_len,center=true);
      }

      translate([(bearing_support_len-clamp_width)/2-spacer,rod_end_dist_to_idler_y,rod_end_dist_to_idler_z]) {
        rotate([0,90,0]) rotate([0,0,22.5])
          cylinder(r=(belt_bearing_nut_diam+min_material_thickness*2)/2,h=bearing_support_len,center=true);

        translate([spacer/2,0,0]) rotate([0,90,0]) rotate([0,0,22.5])
          cylinder(r=(belt_bearing_inner+min_material_thickness)/2,h=bearing_support_len+spacer,center=true,$fn=8);
      }

      translate([0,clamp_len/2,0]) {
        // clamp body
        translate([0,0,clamp_screw_body_height/2+rod_diam/2]) {
          cube([rod_diam,clamp_len,clamp_screw_body_height],center=true);

          translate([-clamp_width/4,0,0]) rotate([0,90,0])
            cylinder(r=clamp_screw_nut_diam*da8,h=clamp_width/2,center=true,$fn=8);
        }
      }
    }

    // screw pad
    hull() {
      translate([0,0,-y_rod_z+screw_pad_height/2]) {
        for(vector=[rod_end_screw_pos,inside_screw_pos,outside_screw_pos]) {
          translate(vector)
            cube([screw_pad_outer_diam+min_material_thickness*1,screw_pad_outer_diam,screw_pad_height],center=true);
        }
        translate([0,clamp_len/2,0])
          cube([clamp_width,clamp_len,screw_pad_height],center=true);

        // endstop base
        if(endstop) {
          translate([y_rod_to_x_clamp_end+min_material_thickness/2,y_clamp_len/2,0]) cube([min_material_thickness,y_clamp_len,screw_pad_height],center=true);
        }
      }
    }

    // endstop holder
    if(endstop) {
      translate([y_rod_to_x_clamp_end+min_material_thickness/2,y_clamp_len/2,-y_rod_z+endstop_holder_len/2]) cube([min_material_thickness,y_clamp_len,endstop_holder_len],center=true);
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

    translate([0,clamp_len/2,clamp_screw_body_height/2+rod_diam/2]) {
      // clamp slot
      translate([0,0,-rod_diam/4+1])
        cube([clamp_gap_width,clamp_len*2,clamp_screw_body_height+rod_diam/2],center=true);

      // clamp screw
      rotate([0,90,0]) rotate([0,0,22.5])
        cylinder(r=clamp_screw_diam*da8,h=clamp_width+3,center=true,$fn=8);

      // clamp screw captive nut
      for(side=[left,right]) {
        translate([(clamp_gap_width/2+min_material_thickness+clamp_screw_nut_thickness)*side,0,0]) rotate([0,90,0]) rotate([0,0,90])
          cylinder(r=clamp_screw_nut_diam*da6,h=5,center=true,$fn=6);
      }
    }
  }

  difference() {
    y_end_front_body();
    y_end_front_holes();
  }
}

module y_end_front_screw_holes() {
  // top plate screw area
  screw_pad_len = y_clamp_len*1.5;
  screw_pad_width = y_clamp_len;

  rod_end_dist_to_idler_x = front_idler_x - y_rod_x;
  rod_end_dist_to_idler_y = front_idler_y - front*y_rod_len/2;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness;

  outside_screw_pos = [-clamp_width,y_end_screw_hole_y,0];
  rod_end_screw_pos = [0,rod_end_dist_to_idler_y-belt_bearing_diam/2,0];
  inside_screw_pos = [clamp_width/2+top_plate_screw_diam+belt_bearing_thickness,y_end_screw_hole_y,0];

  for(coord=[outside_screw_pos,rod_end_screw_pos,inside_screw_pos]) {
    translate(coord) rotate([0,0,22.5])
      cylinder(r=top_plate_screw_diam*da8,h=sheet_thickness*3,center=true,$fn=8);
  }
}

module y_end_rear_screw_holes() {
  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;
  clamp_screw_body_height = clamp_screw_nut_diam+min_material_thickness;

  rod_end_dist_to_lower_idler_x = y_rod_x - lower_rear_idler_x;
  rod_end_dist_to_lower_idler_y = lower_rear_idler_y - rear*y_rod_len/2;
  rod_end_dist_to_lower_idler_z = lower_rear_idler_z - y_rod_z;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  idler_support_thickness = belt_bearing_diam-belt_bearing_thickness-spacer*2;

  bearing_screw_pos = [rod_end_dist_to_lower_idler_x,rod_end_dist_to_lower_idler_y,0];
  inside_screw_pos = [rod_end_dist_to_lower_idler_x+belt_bearing_diam/2+screw_pad_outer_diam/2+spacer,-clamp_len+screw_pad_outer_diam/2,0];
  outside_screw_pos = [-clamp_width,-clamp_len+screw_pad_outer_diam/2,0];
  rod_end_screw_pos = [0,clamp_len+screw_pad_outer_diam/2,0];

  for(vector=[inside_screw_pos,outside_screw_pos,rod_end_screw_pos]) {
    translate(vector) {
      rotate([0,0,22.5]) {
        cylinder(r=da8*top_plate_screw_diam,h=sheet_thickness*3,center=true,$fn=8);
      }
    }
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
  translate([xy_motor_x*right,xy_motor_y,xy_motor_z]) motor_with_pulley();
}

module line() {
  x_most = (xy_idler_x + belt_bearing_diam/2);
  front = -1;
  rear = 1;
  left = -1;
  right = 1;

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

  // front idler to lower rear
  hull() {
    translate([x_most*left,lower_rear_idler_y,lower_rear_idler_z]) cube(line_cube,center=true);
    translate([x_most*left,front_idler_y,lower_rear_idler_z]) cube(line_cube,center=true);
  }

  // lower rear to pulley
  hull() {
    translate([lower_rear_idler_x*left,lower_rear_idler_y+belt_bearing_diam/2,lower_rear_idler_z]) cube(line_cube,center=true);
    translate([xy_motor_x*right,xy_motor_y-pulley_diam/2,lower_rear_idler_z]) cube(line_cube,center=true);
  }

  // pulley to upper rear
  hull() {
    translate([xy_motor_x*right,xy_motor_y-pulley_diam/2,upper_rear_idler_z]) cube(line_cube,center=true);
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
  hole_spacing = 209;
  difference() {
    cube([heatbed_width,heatbed_depth,heatbed_thickness],center=true);
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([heatbed_hole_spacing/2*side,heatbed_hole_spacing/2*end,0])
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
