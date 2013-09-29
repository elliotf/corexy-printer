include <main.scad>;

// x carriage
//translate([-build_x/2,0,x_rod_z]) x_carriage();
translate([-build_x*0/2,0,x_rod_z]) x_carriage();

// y carriage
for(side=[left,right]) {
  translate([y_rod_x*side,0,y_rod_z]) mirror([side+1,0,0]) {
    y_carriage();

    for(end=[front,rear]) {
      translate([y_bar_to_x_clamp_end + clamp_area_width/2 + spacer/2,x_rod_spacing/2*end,0])
        rotate([0,90,0]) rod_clamp(rod_diam);
    }
  }
}

// y end front
for(side=[left,right]) {
  translate([y_rod_x*side,y_rod_len/2*front,y_rod_z]) mirror([side+1,0,0]) y_end_front();
  translate([y_rod_x*side,y_rod_len/2*rear,y_rod_z]) mirror([side+1,0,0]) y_end_rear();
}

// shift one line's bearings up or down to avoid rubbing?
color("green",0.5) idlers();
color("green",0.5) line();
color("red",0.5) mirror([1,0,0]) idlers();
color("red",0.5) mirror([1,0,0]) line();

// top plate
module plates() {
  top_plate_width = y_rod_x*2+sheet_min_width;
  top_plate_depth = y_rod_len+sheet_min_width*2;
  echo("top plate width/depth: ", top_plate_width, "/", top_plate_depth);

  side_depth = top_plate_depth;
  side_height = build_z + sheet_min_width;
  front_back_width = y_rod_x*2-sheet_thickness;

  side_z = -side_height/2-sheet_thickness;

  translate([0,0,-sheet_thickness/2]) {
    difference() {
      translate([0,motor_side/4,0])
        cube([top_plate_width,top_plate_depth,sheet_thickness],center=true);
      cube([build_x+x_carriage_width,build_y+x_rod_spacing,sheet_thickness+1],center=true);
    }
  }

  // front plate
  translate([0,y_rod_len/2*front,side_z]) {
    difference() {
      cube([front_back_width,sheet_thickness,side_height],center=true);
      cube([front_back_width-sheet_min_width*2,sheet_thickness+1,side_height-sheet_min_width*2],center=true);
    }
  }

  // rear plate
  translate([0,y_rod_len/2*rear,side_z]) {
    cube([front_back_width,sheet_thickness,side_height],center=true);
  }

  // side plates
  for(side=[left,right]) {
    translate([y_rod_x*side,motor_side/4,side_z]) {
      difference() {
        cube([sheet_thickness,side_depth,side_height],center=true);

        translate([0,-motor_side/4,0])
          cube([sheet_thickness+1,side_depth-sheet_min_width*2-motor_side/2,side_height-sheet_min_width*2],center=true);
      }
    }
  }
}

color("Khaki", 0.5) plates();


% translate([0,0,-build_z/2]) cube([build_x,build_y,build_z],center=true);

// rods
color("grey", .5) {
  // X
  for(side=[-1,1]) {
    translate([0,(side*x_rod_spacing/2),x_rod_z]) rotate([0,90,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam,h=x_rod_len,center=true,$fn=8);
  }

  // Y
  for(side=[-1,1]) {
    translate([side*y_rod_x,0,y_rod_z]) rotate([90,0,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam,h=y_rod_len,center=true,$fn=8);
  }
}
