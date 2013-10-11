include <main.scad>;

module more_lasercut() {

  sheet_shoulder_width = 4;

  top_sheet_opening_width = build_x+x_carriage_width;
  top_sheet_opening_depth = build_y+x_carriage_depth;

  top_sheet_width = top_sheet_opening_width+motor_side*2+sheet_thickness*2+sheet_shoulder_width*2;
  top_sheet_depth = top_sheet_opening_depth+motor_side*2+sheet_thickness*2+sheet_shoulder_width*2;

  xy_motor_x = y_rod_x;
  xy_motor_y = top_sheet_opening_depth/2+motor_side/2+sheet_thickness+sheet_shoulder_width;//top_sheet_opening_depth/2;

  front_sheet_y = -top_sheet_opening_depth/2-sheet_shoulder_width-sheet_thickness/2;
  front_sheet_height = motor_side;
  front_sheet_width = xy_motor_x*2+motor_side;

  rear_sheet_y = -top_sheet_opening_depth/2-sheet_shoulder_width-sheet_thickness/2;
  rear_sheet_height = motor_side;
  rear_sheet_width = xy_motor_x*2+motor_side;

  //y_rod_len = build_y+x_carriage_depth+sheet_thickness*2+sheet_shoulder_width*2;
  y_rod_len = top_sheet_opening_depth+sheet_thickness*2+sheet_shoulder_width*2;

  echo("y_rod_len (LS): ", y_rod_len);
  echo("x_rod_len (LS): ", x_rod_len);
  y_rod_y = sheet_thickness/2*front*0;
  rod_z = -sheet_thickness/2-belt_bearing_diam/2-belt_bearing_thickness/2-belt_bearing_nut_thickness;
  pulley_height = belt_bearing_diam;

  xy_idler_z = rod_z+belt_bearing_diam/2;

  front_outer_idler_x = y_rod_x;
  front_outer_idler_y = (y_rod_len/2+belt_bearing_diam)*front;
  front_outer_idler_z = xy_idler_z - pulley_height;

  front_inner_idler_x = xy_idler_x;
  front_inner_idler_y = (top_sheet_opening_depth/2+belt_bearing_diam/2+sheet_thickness+spacer)*front;
  front_inner_idler_z = xy_idler_z;

  for(side=[left,right]) {
    translate([y_rod_x*side,y_rod_y,rod_z]) {
      rotate([90,0,0])
        % cylinder(r=rod_diam/2,h=y_rod_len,center=true);
      mirror([side+1,0,0]) y_carriage();
    }

    color("blue", .4)  {
      // carriage idlers
      for(end=[front,rear]) {
        translate([xy_idler_x*side,xy_idler_y*end,rod_z+belt_bearing_diam/2]) {
          idler_bearing();
        }
      }

      // front inner idler
      translate([front_inner_idler_x*side,front_inner_idler_y,front_inner_idler_z]) idler_bearing();

      // front outer idler
      translate([front_outer_idler_x*side,front_outer_idler_y,front_outer_idler_z]) idler_bearing();
    }


    // motors
    color("red",.5)
      translate([xy_motor_x*side,xy_motor_y,0]) {
        translate([0,0,sheet_thickness/2]) rotate([180,0,0])
          motor();
        translate([0,0,xy_idler_z-pulley_height/2])
          cylinder(r=pulley_diam/2,h=pulley_height,center=true);
      }
  }

  // top sheet
  % difference() {
    translate([0,motor_side/8,0]) cube([top_sheet_width,top_sheet_depth,sheet_thickness],center=true);
    cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);
  }

  // front sheet
  % translate([0,front_sheet_y,-front_sheet_height/2]) rotate([90,0,0]) difference() {
    cube([front_sheet_width,front_sheet_height,sheet_thickness],center=true);
  }

  // rear sheet
  % translate([0,rear_sheet_y,-rear_sheet_height/2]) rotate([90,0,0]) difference() {
    cube([rear_sheet_width,rear_sheet_height,sheet_thickness],center=true);
  }
}

more_lasercut();
