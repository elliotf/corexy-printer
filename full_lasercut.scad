include <main.scad>;

x = 0;
y = 1;
z = 2;

module more_lasercut() {
  sheet_shoulder_width = 3;

  top_sheet_opening_width = build_x+x_carriage_width;
  top_sheet_opening_depth = build_y+x_carriage_depth;

  xy_motor_x = y_rod_x;

  top_sheet_width = top_sheet_opening_width+motor_side*2+sheet_thickness*2+sheet_shoulder_width*2;
  top_sheet_width = (xy_motor_x+motor_side/2+spacer+sheet_thickness+sheet_shoulder_width)*2;
  top_sheet_depth = top_sheet_opening_depth+motor_side+sheet_thickness*2+sheet_shoulder_width*2;

  //y_rod_len = build_y+x_carriage_depth+sheet_thickness*2+sheet_shoulder_width*2;
  y_rod_len = top_sheet_opening_depth+sheet_thickness*2+sheet_shoulder_width*2;
  y_rod_y = 0;
  rod_z = -belt_bearing_diam/2-belt_bearing_thickness/2-belt_bearing_nut_thickness-spacer;
  y_rod_z = rod_z;
  x_rod_z = y_rod_z;
  echo("y_rod_len (LS): ", y_rod_len);
  echo("x_rod_len (LS): ", x_rod_len);

  rear_sheet_y = top_sheet_opening_depth/2+sheet_shoulder_width+sheet_thickness/2;

  pulley_height = belt_bearing_diam;

  xy_idler_z = rod_z+belt_bearing_diam/2;

  front_idler_x = xy_idler_x+belt_bearing_diam/2;
  front_idler_y = (y_rod_len/2+belt_bearing_diam/2+spacer)*front;
  front_idler_z = y_rod_z;

  to_motor_idler_x = front_idler_x;
  to_motor_idler_y = rear_sheet_y-sheet_thickness/2;
  to_motor_idler_z = front_idler_z-belt_bearing_diam*1.25;

  return_idler_x = front_idler_x;
  return_idler_y = rear_sheet_y-belt_bearing_diam/2+sheet_thickness/2+belt_bearing_diam+spacer;
  return_idler_z = xy_idler_z;

  xy_motor_y = top_sheet_opening_depth/2+sheet_shoulder_width;
  xy_motor_z = to_motor_idler_z-belt_bearing_diam/2-spacer*2-motor_side/2;

  rear_sheet_width = top_sheet_width;
  rear_sheet_height = xy_motor_z*-1+motor_side/2;
  rear_sheet_z = -rear_sheet_height/2;

  front_sheet_y = -top_sheet_opening_depth/2-sheet_shoulder_width-sheet_thickness/2;
  front_sheet_height = rear_sheet_height;
  front_sheet_width = top_sheet_width;

  side_sheet_depth = -front_sheet_y+rear_sheet_y-sheet_thickness;
  side_sheet_height = rear_sheet_height;
  side_sheet_x = xy_motor_x+motor_side/2+sheet_thickness/2+spacer;
  side_sheet_z = -side_sheet_height/2;

  motor_idler_dist = abs(xy_motor_z) - abs(xy_idler_z) - pulley_diam/3;
  short = motor_idler_dist;
  long  = (xy_motor_x)*2;
  echo("SHORT (ADJACENT): ", short);
  echo("LONG (OPPOSITE): ", long);
  return_idler_angle = atan((abs(xy_motor_z)-abs(xy_idler_z))/front_idler_x*2);
  return_idler_angle = atan(long/short);
  echo("ANGLE: ", return_idler_angle);

  debug_len = 1000;
  debug_len = 0;

  for(side=[left,right]) {
    translate([y_rod_x*side,y_rod_y,rod_z]) {
      rotate([90,0,0])
        color("grey", .6) cylinder(r=rod_diam/2,h=y_rod_len,center=true);
      mirror([side+1,0,0]) y_carriage();
    }
  }

  module line() {
    x_carriage = x_carriage_width/2;
    y_carriage = xy_idler_y-belt_bearing_diam/2;
    x_most     = xy_idler_x+belt_bearing_diam/2;

    module dot() {
      cube(line_cube,center=true);
    }

    // x carriage front to y carriage front
    hull() {
      translate([x_carriage*left,y_carriage*front,xy_idler_z]) dot();
      translate([xy_idler_x*left,y_carriage*front,xy_idler_z]) dot();
    }

    translate([xy_idler_x*left,xy_idler_y*front,xy_idler_z]) idler_bearing();

    // y carriage to front idler
    hull() {
      translate([x_most*left,xy_idler_y*front,xy_idler_z]) dot();
      translate([front_idler_x*left,front_idler_y,xy_idler_z]) dot();
    }

    translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();

    // front to motor idler
    hull() {
      translate([front_idler_x*left,front_idler_y,xy_idler_z-belt_bearing_diam]) dot();
      translate([to_motor_idler_x*left,to_motor_idler_y,to_motor_idler_z+belt_bearing_diam/2]) dot();
    }

    translate([to_motor_idler_x*left,to_motor_idler_y,to_motor_idler_z]) rotate([0,90,0]) idler_bearing();

    // motor idler to pulley
    hull() {
      translate([to_motor_idler_x*left,to_motor_idler_y+belt_bearing_diam/2,to_motor_idler_z]) dot();
      translate([(xy_motor_x-pulley_diam/2)*left,xy_motor_y+pulley_height/2,xy_motor_z]) dot();
    }

    translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) {
      rotate([-90,0,0])
        motor_with_pulley();
    }

    // pulley to return idler
    hull() {
      translate([xy_motor_x*left,xy_motor_y+pulley_height*1.5,xy_motor_z+pulley_diam/2]) dot();
      translate([(return_idler_x-belt_bearing_diam/2)*right,return_idler_y+belt_bearing_diam/2,return_idler_z-belt_bearing_thickness/3]) dot();
    }

    translate([return_idler_x*right,return_idler_y,return_idler_z])
      rotate([0,return_idler_angle*right,0]) {
        translate([0,0,-belt_bearing_diam/2]) rotate([0,90,0])
          idler_bearing();
        # translate([0,0,-debug_len/2]) cylinder(r=1,h=debug_len,center=true);
      }

    // return idler to y carriage rear
    hull() {
      translate([return_idler_x*right,return_idler_y,return_idler_z]) dot();
      translate([x_most*right,xy_idler_y*rear,xy_idler_z]) dot();
    }

    translate([xy_idler_x*right,xy_idler_y*rear,xy_idler_z]) idler_bearing();

    // y carriage rear to x carriage rear
    hull() {
      translate([x_carriage*right,y_carriage*rear,xy_idler_z]) dot();
      translate([xy_idler_x*right,y_carriage*rear,xy_idler_z]) dot();
    }
  }

  color("green", 0.6) line();
  color("red", 0.6) mirror([1,0,0]) line();

  color("grey", .3) {
    // front sheet
    translate([0,front_sheet_y,-front_sheet_height/2]) rotate([90,0,0]) difference() {
      cube([front_sheet_width,front_sheet_height,sheet_thickness],center=true);
    }

    // rear sheet
    translate([0,rear_sheet_y,rear_sheet_z]) rotate([90,0,0]) difference() {
      cube([rear_sheet_width,rear_sheet_height,sheet_thickness],center=true);

      translate([0,-rear_sheet_z,0]) {
        for(side=[left,right]) {
          // holes for "to motor" idler
          translate([to_motor_idler_x*side,to_motor_idler_z,0])
            cube([belt_bearing_thickness*2+min_material_thickness*2,belt_bearing_diam+min_material_thickness*2,sheet_thickness+1],center=true);
        }
      }
    }

    // top sheet
    translate([0,0,sheet_thickness/2]) difference() {
      cube([top_sheet_width,top_sheet_depth,sheet_thickness],center=true);
      cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);
    }

    // side sheets
    for(side=[left,right]) {
      translate([side_sheet_x*side,0,side_sheet_z]) rotate([90,0,90]) difference() {
        cube([side_sheet_depth,side_sheet_height,sheet_thickness],center=true);
      }
    }
  }
}

more_lasercut();
