include <config.scad>;
use <lib/boxcutter/main.scad>;
use <util.scad>;

min_material_thickness = 1;
sheet_opacity          = 1;
sheet_opacity          = 0.4;

spool_diam = 18;
spool_len  = 25.5;

x_rod_spacing        = bearing_diam + min_material_thickness * 2 + rod_diam;
x_carriage_width     = bearing_len + min_material_thickness * 2;

y_carriage_belt_bearing_y = rod_diam/2+belt_bearing_inner/2 + min_material_thickness;
y_carriage_belt_bearing_z = -rod_diam/2-belt_bearing_inner/2+belt_bearing_effective_diam/2;
y_carriage_lower_belt_bearing_z = -x_rod_spacing/2+rod_diam/2+2+belt_bearing_thickness/2;
y_belt_bearing_from_rod   = 3;
y_carriage_width          = min_material_thickness*2 + bearing_diam + min_material_thickness + spacer + belt_bearing_diam;
y_carriage_depth          = (y_carriage_belt_bearing_y + belt_bearing_nut_diam/2 + min_material_thickness*2)*2;
y_carriage_height         = x_rod_spacing+rod_diam+min_material_thickness*4;
y_carriage_space          = y_carriage_belt_bearing_y*2+belt_bearing_diam;

x_rod_len            = build_x + x_carriage_width + y_carriage_width*2 + 1;
//x_rod_len            = 265;
x_carriage_height    = x_rod_spacing + bearing_diam + min_material_thickness*2;
x_carriage_thickness = bearing_diam;

hotend_y    = (bearing_diam/2 + spacer + hotend_diam/2)*front;
hotend_z    = x_carriage_height/2 + -hotend_len/2 + hotend_clamped_height;

y_rod_clamp_len = 8;
top_rear_brace_depth = 8 + z_rod_diam/2 + z_bearing_diam/2 + sheet_thickness + 2 + belt_bearing_thickness;
top_rear_brace_depth = 8 + z_rod_diam/2 + z_bearing_diam/2 + sheet_thickness;
min_top_rear_brace_depth = 30;
//y_rod_len       = build_y + y_carriage_space/2 + abs(hotend_y) + 2 + sheet_thickness*2 + y_rod_clamp_len*2 + 7;
y_rod_len       = hotend_diam/2 + build_y + hotend_diam/2 + abs(hotend_y) + top_rear_brace_depth + sheet_thickness*2 + y_rod_clamp_len*2;
//y_rod_len       = 265;
y_rod_x         = x_rod_len/2 - bearing_diam/2 - min_material_thickness*2;

y_carriage_belt_bearing_x = y_rod_x - bearing_diam/2 - min_material_thickness - spacer - belt_bearing_diam/2;

min_sheet_material = 3;

top_of_sheet = x_rod_spacing/2;
hotend_sheet_clearance = (hotend_z-hotend_len/2-top_of_sheet-sheet_thickness*2)*bottom;

build_pos_x = 0;
build_pos_z = hotend_z-hotend_len/2-build_z/2-1;

space_between_y_rod_and_sheet = bearing_diam/2 + 5;
side_sheet_pos_x = y_rod_x + space_between_y_rod_and_sheet + sheet_thickness/2;
side_sheet_pos_y = 0;

heatbed_and_glass_thickness = 4;

z_axis_overhead = sheet_thickness + heatbed_and_glass_thickness + motor_side;

front_sheet_width = side_sheet_pos_x*2 - sheet_thickness;
rear_sheet_width  = front_sheet_width;

top_sheet_pos_z    = -y_carriage_height/2-5-sheet_thickness/2; // below gantry
//top_sheet_pos_z    = y_carriage_height/2+5+sheet_thickness/2; // above gantry
bottom_sheet_pos_z = build_pos_z - build_z/2 - z_axis_overhead - sheet_thickness/2;
z_rod_len          = (top_sheet_pos_z - bottom_sheet_pos_z) + sheet_thickness;

sheet_height       = top_of_sheet - bottom_sheet_pos_z - sheet_thickness/2;
side_sheet_height  = (top_sheet_pos_z - bottom_sheet_pos_z) + min_sheet_material;
side_sheet_height  = sheet_height;
//sheet_height = top_sheet_pos_z - bottom_sheet_pos_z + sheet_thickness + min_sheet_material*2; // above gantry

sheet_pos_y = y_rod_len/2-y_rod_clamp_len-sheet_thickness/2;
sheet_pos_z = top_of_sheet-sheet_height/2; // below gantry
side_sheet_pos_z   = top_sheet_pos_z - sheet_thickness/2 - side_sheet_height/2;
side_sheet_pos_z   = sheet_pos_z;
//sheet_pos_z = top_sheet_pos_z+sheet_thickness/2+min_sheet_material-sheet_height/2; // above gantry

top_sheet_depth = sheet_pos_y*2-sheet_thickness;

side_sheet_depth = sheet_pos_y*2 - sheet_thickness;

z_rod_pos_x  = max(build_x*0.33);
z_rod_pos_y  = rear*sheet_pos_y + sheet_thickness/2 - z_motor_shaft_len + belt_width/2;
z_rod_pos_z  = bottom_sheet_pos_z - sheet_thickness/2 + z_rod_len/2;

z_belt_bearing_diam      = 10;
z_belt_bearing_inner     = 3;
z_belt_bearing_thickness = 8; // F623ZZ * 2
z_pulley_diam  = (16*2)/approx_pi;
z_motor_pos_x  = z_belt_bearing_diam/2 + belt_thickness + z_pulley_diam/2;
z_motor_pos_y  = rear*sheet_pos_y + sheet_thickness/2;
z_motor_pos_z  = bottom_sheet_pos_z + sheet_thickness/2 + motor_side/2 - (z_motor_side-z_motor_hole_spacing)/2 + z_motor_screw_diam/2 + 2;
z_idler_pos_z  = top_sheet_pos_z - sheet_thickness/2 - z_pulley_diam/2 - 3;

main_opening_width  = (y_rod_x - bearing_diam/2 - belt_bearing_diam)*2;
main_opening_depth  = top_sheet_depth/2 + z_rod_pos_y - z_bearing_diam/2 - sheet_thickness;

build_pos_y = main_opening_depth - top_sheet_depth/2 - hotend_diam/2 - 5 - build_y/2;

x_pos = -build_x/2+0;
y_pos = (build_pos_y-build_y/2-hotend_y)+build_y*1;

echo("X/Y/Z ROD LEN: ", x_rod_len, y_rod_len, z_rod_len);
echo("W/D/H: ", front_sheet_width, side_sheet_depth, sheet_height);

module belt_bearing() {
  res = 24;

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

% for (end=[left,right]) {
  // y rods
  translate([y_rod_x*end,0,0]) {
    rotate([90,0,0]) {
      cylinder(r=rod_diam/2,h=y_rod_len,center=true,$fn=16);
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
  rod_bearing_x  = min_material_thickness*2 + bearing_diam/2;
  belt_bearing_x = rod_bearing_x + (y_rod_x - y_carriage_belt_bearing_x);

  x_rod_clamp_len = belt_bearing_x + belt_bearing_nut_diam/2 + min_material_thickness*2;

  module body() {
    // main body, hold x rods
    hull() {
      for(side=[top,bottom]) {
        translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            hole(rod_diam+min_material_thickness*4,x_rod_clamp_len,32);
          }
        }
      }
      translate([bearing_diam/2,0,0]) {
        cube([bearing_diam,y_carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
    }
    hull() {
      translate([bearing_diam/2,0,0]) {
        cube([bearing_diam,y_carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
      translate([belt_bearing_x+belt_bearing_diam/2,0,0]) {
        //cube([bearing_diam,y_carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
      translate([belt_bearing_x,0,0]) {
        cube([belt_bearing_nut_diam+min_material_thickness*4,.1,y_carriage_height],center=true);
        translate([0,y_carriage_belt_bearing_y,0]) {
          hole(belt_bearing_nut_diam+min_material_thickness*4,y_carriage_height,resolution);
        }
      }
    }
  }

  module holes() {
    // x rods
    for(side=[top,bottom]) {
      translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(rod_diam,x_rod_clamp_len+4,resolution);
        }
      }
    }

    // y rod bearing
    translate([rod_bearing_x,0,0]) {
      // overhang bearing opening
      /*
      intersection() {
        rotate([90,0,0]) {
          hole(bearing_diam,bearing_len*2,8);
        }
        translate([bearing_diam/2,0,0]) {
          cube([bearing_diam*.35,bearing_len*2,bearing_diam*2],center=true);
        }
      }
      */
      // non-overhang bearing opening
      rotate([90,0,0]) {
        rotate([0,0,22.5/4]) {
          hole(bearing_diam,bearing_len*2,32);
        }
      }
    }

    // room for belt/filament
    translate([belt_bearing_x,y_carriage_belt_bearing_y,y_carriage_lower_belt_bearing_z]) {
      hole(belt_bearing_diam + spacer*2,belt_bearing_thickness+1,16);
      hole(belt_bearing_inner,50,8);

      // room for belt/filament
      translate([0,belt_bearing_diam/2,0]) {
        cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_thickness+1],center=true);
      }
    }
    /*
    translate([belt_bearing_x+belt_bearing_diam/2,0,y_carriage_lower_belt_bearing_z]) {
      hull() {
        cube([belt_bearing_diam,belt_bearing_diam*2,belt_bearing_thickness*2+1],center=true);
        // upper belt bearing
        translate([0,0,belt_bearing_thickness]) {
          cube([belt_bearing_diam,belt_bearing_diam*2,belt_bearing_thickness*2+1],center=true);
        }
      }
    }

    for (side=[front,rear]) {
      translate([belt_bearing_x,y_carriage_belt_bearing_y*side,y_carriage_lower_belt_bearing_z]) {
        rotate([0,0,22.5/2]) {
          hole(belt_bearing_diam + spacer*2,belt_bearing_thickness+1,16);
        }

        rotate([0,0,22.5]) {
          hole(belt_bearing_inner,50,8);
        }

        // room for belt/filament
        translate([0,belt_bearing_diam/2*side,0]) {
          cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_thickness+1],center=true);
        }
      }
    }
    */
  }

  difference() {
    body();
    holes();
  }

  translate([rod_bearing_x,0,0]) {
    rotate([90,0,0]) {
      % cylinder(r=bearing_diam/2,h=bearing_len,center=true);
    }
  }
  % translate([belt_bearing_x,y_carriage_belt_bearing_y,y_carriage_lower_belt_bearing_z]) {
    belt_bearing();
    translate([0,0,belt_bearing_thickness+.5]) {
      belt_bearing();
    }
  }
}

module old_y_carriage() {
  res = 24;

  rod_bearing_x  = min_material_thickness*2 + bearing_diam/2;
  belt_bearing_x = rod_bearing_x + (y_rod_x - y_carriage_belt_bearing_x);

  x_rod_clamp_len = belt_bearing_x + belt_bearing_nut_diam/2 + min_material_thickness*2;

  module body() {
    // main body, hold x rods
    hull() {
      for(side=[top,bottom]) {
        translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            rotate([0,0,22.5/4]) {
              hole(rod_diam+min_material_thickness*4,x_rod_clamp_len,32);
            }
          }
        }
      }
      translate([bearing_diam/2,0,0]) {
        cube([bearing_diam,y_carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
    }
    /*
    hull() {
      translate([bearing_diam/2,0,0]) {
        cube([bearing_diam,y_carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
      for(side=[front,rear]) {
        translate([belt_bearing_x,y_carriage_belt_bearing_y*side,0]) {
          rotate([0,0,22.5/2]) {
            hole(belt_bearing_nut_diam+min_material_thickness*4,y_carriage_height,16);
          }
        }
      }
    }
    */
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(rod_diam,x_rod_clamp_len+4,res);
        }
      }
    }

    translate([rod_bearing_x,0,0]) {
      // overhang bearing opening
      intersection() {
        rotate([90,0,0]) {
          rotate([0,0,22.5]) {
            hole(bearing_diam,bearing_len*2,8);
          }
        }
        translate([bearing_diam/2,0,0]) {
          cube([bearing_diam*.35,bearing_len*2,bearing_diam*2],center=true);
        }
      }
      // non-overhang bearing opening
      rotate([90,0,0]) {
        rotate([0,0,22.5/4]) {
          hole(bearing_diam,bearing_len*2,32);
        }
      }
    }

    // room for belt/filament
    translate([belt_bearing_x+belt_bearing_diam/2,0,y_carriage_belt_bearing_z]) {
      cube([belt_bearing_diam,belt_bearing_diam*2,belt_bearing_thickness+1],center=true);
    }

    for (side=[front,rear]) {
      translate([belt_bearing_x,y_carriage_belt_bearing_y*side,y_carriage_belt_bearing_z]) {
        rotate([0,0,22.5/2]) {
          hole(belt_bearing_diam + spacer*2,belt_bearing_thickness+1,16);
        }

        rotate([0,0,22.5]) {
          hole(belt_bearing_inner,50,8);
        }

        // room for belt/filament
        translate([0,belt_bearing_diam/2*side,0]) {
          cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_thickness+1],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  translate([rod_bearing_x,0,0]) {
    rotate([90,0,0]) {
      % cylinder(r=bearing_diam/2,h=bearing_len,center=true);
    }
  }
  for (side=[front,rear]) {
    % translate([belt_bearing_x,y_carriage_belt_bearing_y*side,y_carriage_belt_bearing_z]) {
      belt_bearing();
      translate([25,-belt_bearing_effective_diam/2*side,0]) {
        cube([50,.5,.5],center=true);
      }
    }
  }
}

module front_sheet() {
  bottom_material  = 30;
  opening_height   = min((sheet_height - bottom_material),(sheet_height*.50));

  module body() {
    box_side([front_sheet_width,sheet_height],[0,4,4,4]);
  }

  module holes() {
    hull() {
      translate([0,sheet_height/2,0]) {
        cube([build_x,opening_height*2,sheet_thickness+1],center=true);
        cube([main_opening_width-sheet_thickness*2,hotend_sheet_clearance*2,sheet_thickness+1],center=true);
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
    translate([z_motor_pos_x,-sheet_pos_z+z_motor_pos_z,0]) {
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

  difference() {
    body();
    holes();
  }
}

module side_sheet() {
  bottom_material  = 30;
  hotend_clearance = -1*(hotend_z-hotend_len/2-top_of_sheet);

  opening_height = min((sheet_height - bottom_material),(sheet_height*.66));
  //height = (top_sheet_pos_z - bottom_sheet_pos_z) + sheet_thickness/2 + min_sheet_material;

  module body() {
    box_side([side_sheet_depth,side_sheet_height],[0,3,4,3]);
  }

  module holes() {
    cube([side_sheet_depth/2,sheet_height/2,sheet_thickness+1],center=true);
  }

  difference() {
    body();
    holes();
  }
}

module top_sheet() {
  width = side_sheet_pos_x*2 + sheet_thickness + min_sheet_material*2;
  width = side_sheet_pos_x*2 - sheet_thickness;

  module body() {
    box_side([width,top_sheet_depth],[3,3,3,3]);
  }

  module holes() {
    translate([0,top_sheet_depth/2*front,0]) {
      cube([main_opening_width,main_opening_depth*2,sheet_thickness+1],center=true);
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
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  translate([0,y_pos,0]) {
    for(side=[left,right]) {
      mirror([1+side,0,0]) {
        translate([-x_rod_len/2,0,0]) {
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
    color("gold", sheet_opacity) {
      rotate([90,0,0]) {
        rear_sheet();
      }
    }
  }

  for(side=[left,right]) {
    translate([side_sheet_pos_x*side,side_sheet_pos_y,side_sheet_pos_z]) {
      rotate([0,90*side,0]) {
        rotate([0,0,90*side]) {
          color("lightgreen", sheet_opacity) {
            side_sheet();
          }
        }
      }
    }
  }

  // messing around with line return
  for(side=[left,right]) {
    translate([(y_carriage_belt_bearing_x+belt_bearing_effective_diam/2)*side,(sheet_pos_y+sheet_thickness/2+belt_bearing_diam/2+spacer)*front,y_carriage_belt_bearing_z-belt_bearing_effective_diam/2]) {
      rotate([0,90,0]) {
        belt_bearing();
      }
    }
  }
  for(side=[left,right]) {
    translate([(y_carriage_belt_bearing_x+belt_bearing_effective_diam/2)*side,(sheet_pos_y+sheet_thickness/2+belt_bearing_diam/2+spacer)*rear,y_carriage_belt_bearing_z]) {
      rotate([0,-10*side,0]) {
        translate([belt_bearing_effective_diam/2*-side,0,0]) {
          belt_bearing();
        }
      }
    }
  }

  // xy motors
  /*
  // inside
  for(side=[left,right]) {
    translate([(side_sheet_pos_x-sheet_thickness/2-motor_side/2)*side,sheet_pos_y-sheet_thickness/2,top_sheet_pos_z-sheet_thickness/2-motor_side/2-5]) {
      rotate([-90,0,0]) {
        % motor();
      }
    }
  }
  */
  // on the back
  /*
  for(side=[left,right]) {
    translate([(side_sheet_pos_x-sheet_thickness/2-motor_side/2)*side,sheet_pos_y+sheet_thickness/2+motor_side/2,bottom_sheet_pos_z+sheet_thickness/2+motor_side/2]) {
      rotate([0,90*side,0]) {
        % motor();

        translate([0,0,0]) {
        }
      }
    }
  }
  */
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

    cube([build_x+14,build_y+14,sheet_thickness],center=true);
  }

  z_belt_bearing_diam = 10;
  z_belt_pulley_diam  = 10;
  motor_pos_z         = top_sheet_pos_z-sheet_thickness/2-motor_side/2;
  motor_pos_z         = bottom_sheet_pos_z+sheet_thickness/2+motor_side/2;
}

translate([0,0,build_z*1]) {
  z_axis();
}

assembly();
