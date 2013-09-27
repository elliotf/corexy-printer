da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

left  = -1;
right = 1;
front = -1;
rear  = 1;

build_x = 150;
build_y = 150;
build_z = 150;

// lm8uu, M8 rods
lm8uu_bearing_diam = 15;
lm8uu_bearing_len  = 24;
lm8uu_rod_diam = 8;

// lm6uu, M6 rods
lm6uu_bearing_diam = 12;
lm6uu_bearing_len  = 19;
lm6uu_rod_diam = 6;

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
pulley_diam = 18;
pulley_height = belt_bearing_diam + 8;
min_material_thickness = 2;

sheet_thickness = 6;
sheet_min_width = 30;
spacer = 1;

y_clamp_len = 10; // amount of bar to clamp onto
x_rod_spacing = 36 + lm8uu_bearing_diam;
x_carriage_width = bearing_len * 2 + 10;

clamp_screw_diam = 3;
clamp_screw_nut_diam = 5.5;

top_plate_screw_diam = 3;

rod_z = belt_bearing_diam/2 + belt_bearing_thickness/2 + spacer*2;

// X rods
x_rod_clamp_len = bearing_len*2 + spacer + min_material_thickness*2;
x_rod_len = build_x + x_carriage_width + belt_bearing_diam*2 + bearing_diam;
x_rod_z = rod_z;
echo("X rod len: ", x_rod_len);

// Y rods
y_rod_len = build_y + x_rod_spacing + sheet_min_width*2;
y_rod_x = x_rod_len/2;
y_rod_z_distance_to_x = 0;
y_rod_z = rod_z + y_rod_z_distance_to_x;
echo("Y rod len: ", y_rod_len);


xy_idler_x = y_rod_x - bearing_diam/2 - belt_bearing_diam/2 - min_material_thickness - spacer;
xy_idler_y = x_rod_spacing/2 - rod_diam/2 - belt_bearing_inner/2 - min_material_thickness;
xy_idler_z = x_rod_z + belt_bearing_diam/2 + .5;

front_idler_x = xy_idler_x + belt_bearing_diam/2;
front_idler_y = -y_rod_len/2 - belt_bearing_inner/2 - min_material_thickness/2;
front_idler_z = xy_idler_z - belt_bearing_diam/2;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
//lower_rear_idler_y = y_rod_len/2 + belt_bearing_diam/2 + belt_bearing_inner;
lower_rear_idler_y = y_rod_len/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
//upper_rear_idler_y = lower_rear_idler_y - belt_bearing_diam/2 - belt_bearing_inner;
upper_rear_idler_y = lower_rear_idler_y;
upper_rear_idler_z = xy_idler_z;

avoid_crossing = 10;
xy_motor_x = motor_side/2 + spacer;
//xy_motor_y = lower_rear_idler_y + belt_bearing_diam/2 + pulley_diam/2 - belt_bearing_inner/2;
xy_motor_y = lower_rear_idler_y + belt_bearing_diam/2 + pulley_diam/2 + avoid_crossing;
xy_motor_z = -sheet_thickness;

module motor() {
  translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
  cylinder(r=5/2,h=motor_side,center=true);

  translate([0,0,sheet_thickness+spacer+pulley_height/2]) cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing() {
  rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
    cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true);
  }
}

// y carriage
y_carriage_len = x_rod_spacing + rod_diam + min_material_thickness*2;

module y_carriage() {
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

module y_end_rear() {
  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len + 1;

  screw_one = [-clamp_width,clamp_len-screw_pad_outer_diam/2,0];
  screw_two = [-clamp_width,rod_end_dist_to_idler_y,0];
  screw_three = [clamp_width/2-top_plate_screw_diam/2,rod_end_dist_to_idler_y-belt_bearing_diam/2+1,0];
  screw_four = [0,clamp_len-screw_pad_outer_diam/2,0];

  module y_end_rear_body() {
    translate([0,-clamp_len/2+(clamp_len-y_clamp_len),0]) {
      // rod hole body
      translate([0,0,-y_rod_z/2])
        cube([clamp_width,clamp_len,y_rod_z],center=true);
      rotate([90,0,0])
        cylinder(r=clamp_width/2,h=clamp_len,center=true);
    }
  }

  module y_end_rear_holes() {
    translate([0,-clamp_len/2,0]) {
      // y rod hole
      rotate([90,0,0]) cylinder(r=da8*rod_diam,h=y_clamp_len+1,center=true,$fn=8);
    }
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
  screw_pad_height = min_material_thickness*2;
  screw_pad_outer_diam = top_plate_screw_diam+min_material_thickness*2;

  rod_end_dist_to_idler_x = front_idler_x - y_rod_x;
  rod_end_dist_to_idler_y = front_idler_y - front*y_rod_len/2;
  rod_end_dist_to_idler_z = front_idler_z - y_rod_z;

  clamp_width = rod_diam+min_material_thickness*2;
  clamp_len = y_clamp_len;

  screw_one = [-clamp_width,clamp_len-screw_pad_outer_diam/2,0];
  screw_two = [-clamp_width,rod_end_dist_to_idler_y,0];
  screw_three = [clamp_width/2-top_plate_screw_diam/2,rod_end_dist_to_idler_y-belt_bearing_diam/2+1,0];
  screw_four = [0,clamp_len-screw_pad_outer_diam/2,0];

  module y_end_front_body() {
    bearing_support_len = rod_end_dist_to_idler_x*-1-belt_bearing_thickness/2+rod_diam/2+min_material_thickness;

    // y clamp area
    hull() {
      translate([0,clamp_len/2-(clamp_len-y_clamp_len),0]) {
        // rod hole body
        translate([0,0,-y_rod_z/2])
          cube([clamp_width,clamp_len,y_rod_z],center=true);
        rotate([90,0,0])
          cylinder(r=clamp_width/2,h=clamp_len,center=true);
      }
      translate([(bearing_support_len-clamp_width)/2-spacer,rod_end_dist_to_idler_y,rod_end_dist_to_idler_z]) rotate([0,90,0]) rotate([0,0,22.5])
        cylinder(r=(belt_bearing_nut_diam+min_material_thickness*2)/2,h=bearing_support_len,center=true);
    }

    // screw pad
    hull() {
      translate([0,0,-y_rod_z+screw_pad_height/2]) {
        translate(screw_one) rotate([0,0,22.5])
          cylinder(r=da8*screw_pad_outer_diam,h=screw_pad_height,center=true,$fn=8);

        for(vector=[screw_two,screw_three,screw_four]) {
          translate(vector)
            cylinder(r=screw_pad_outer_diam/2,h=screw_pad_height,center=true);
        }
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
      for(coord=[screw_one,screw_two,screw_three]) {
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
  translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) motor();
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
    translate([carriage_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([xy_idler_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage front to front idler
  hull() {
    translate([x_most*left,xy_idler_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*left,front_idler_y,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // front idler to lower rear
  hull() {
    translate([x_most*left,lower_rear_idler_y,lower_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*left,front_idler_y,lower_rear_idler_z]) cube([1,1,1],center=true);
  }

  // lower rear to pulley
  hull() {
    translate([lower_rear_idler_x*left,lower_rear_idler_y+belt_bearing_diam/2,lower_rear_idler_z]) cube([1,1,1],center=true);
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,lower_rear_idler_z]) cube([1,1,1],center=true);
  }

  // pulley to upper rear
  hull() {
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([upper_rear_idler_x*right,upper_rear_idler_y+belt_bearing_diam/2,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // upper rear to y carriage rear
  hull() {
    translate([x_most*right,upper_rear_idler_y,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*right,xy_idler_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage rear to x carriage rear
  hull() {
    translate([xy_idler_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([carriage_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }
}
