include <main.scad>;

module top_plate() {
  top_plate_width = y_rod_x*2+sheet_min_width;
  top_plate_depth = y_rod_len+sheet_min_width+motor_side;
  echo("top plate width/depth: ", top_plate_width, "/", top_plate_depth);

  side_depth = top_plate_depth;
  side_height = build_z + sheet_min_width;
  front_back_width = y_rod_x*2-sheet_thickness;

  side_z = -side_height/2-sheet_thickness;

  module sheet_body() {
    translate([0,motor_side/4,-sheet_thickness/2])
      cube([top_plate_width,top_plate_depth,sheet_thickness],center=true);
  }

  module sheet_holes() {
    //translate([0,0,-sheet_thickness/2]) cube([x_rod_len-x_carriage_width,y_rod_len-y_clamp_len*2-sheet_thickness*2,sheet_thickness+1],center=true);
    top_opening_depth = y_rod_len-y_clamp_len*2-sheet_thickness*2;
    top_opening_depth = build_y+x_rod_spacing*.75;
    top_opening_width = x_rod_len-x_carriage_width;
    top_opening_width = build_x+x_carriage_width/2;
    translate([0,top_opening_depth/2*front,-sheet_thickness/2])
      cube([top_opening_width,top_opening_depth*2,sheet_thickness+1],center=true);


    for(side=[left,right]) {
      // y ends
      //% translate([y_rod_x*side,y_rod_len/2*front,y_rod_z]) mirror([side+1,0,0]) y_end_front(1-side);
      translate([y_rod_x*side,y_rod_len/2*front,-sheet_thickness/2]) mirror([side+1,0,0]) y_end_front_screw_holes(1-side);
      //% translate([y_rod_x*side,y_rod_len/2*rear,y_rod_z]) mirror([side+1,0,0]) y_end_rear();
      translate([y_rod_x*side,y_rod_len/2*rear,-sheet_thickness/2]) mirror([side+1,0,0]) y_end_rear_screw_holes();

      // motor holes
      translate([xy_motor_x*side,xy_motor_y*rear,]) {
        cylinder(r=motor_hole_spacing/2,h=sheet_thickness*3,center=true);
        for(motor_side=[left,right]) {
          for(motor_end=[front,rear]) {
            translate([motor_hole_spacing/2*motor_side,motor_hole_spacing/2*motor_end,0]) cylinder(r=motor_screw_diam*da6,h=sheet_thickness*3,center=true,$fn=6);
          }
        }
      }
    }
  }

  difference() {
    sheet_body();
    sheet_holes();
  }

/*
  // front plate
  translate([0,(y_rod_len/2-y_end_screw_hole_y)*front,side_z]) {
    difference() {
      cube([front_back_width,sheet_thickness,side_height],center=true);
      cube([front_back_width-sheet_min_width*2,sheet_thickness+1,side_height-sheet_min_width*2],center=true);
    }
  }

  // rear plate
  translate([0,(y_rod_len/2-y_end_screw_hole_y)*rear,side_z]) {
    cube([front_back_width,sheet_thickness,side_height],center=true);
  }

  // side plates
  for(side=[left,right]) {
    translate([y_rod_x*side,motor_side/4,side_z]) {
      difference() {
        cube([sheet_thickness,side_depth,side_height],center=true);

        translate([0,-motor_side/4,0])
          cube([sheet_thickness+1,y_rod_len-y_end_screw_hole_y*2-sheet_min_width,side_height-sheet_min_width*2],center=true);
      }
    }
  }
  */
}

//color("Khaki") plates();
//projection() color("Khaki") plates();
