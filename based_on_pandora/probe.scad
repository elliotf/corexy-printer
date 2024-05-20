include <./main.scad>;

m2_thread_into_plastic = 1.8;

spring_cavity_diam = 4.5;

extrude_width = 0.45;
wall_thickness = extrude_width*2;

mount_hole_spacing = 30.8;
mount_height = 15; // tune?

magnet_spacing = 28; // slideswipe
//magnet_spacing = 20.32; // unclid
magnet_diam = 6;
magnet_thickness = 3;
magnet_stickout = 0.2;

meat_above_magnet = 0.8;

magnet_cavity_diam = magnet_diam+0.1;
magnet_cavity_height = magnet_thickness-magnet_stickout;

probe_height = 15;
probe_width = magnet_diam + 2*(extrude_width*4);
probe_length = magnet_spacing + probe_width;

//plunger_length = magnet_spacing-magnet_diam-wall_thickness*4;
plunger_length = min(magnet_spacing-magnet_diam-wall_thickness*4,10);
//plunger_width = probe_width-2*(extrude_width*4);
plunger_magnet_stickout = 1;
plunger_space_between_magnets = 1.5;
plunger_tip_height = 2;
plunger_stickout = plunger_tip_height;
plunger_width = magnet_diam-1;
plunger_height = probe_height-meat_above_magnet-magnet_thickness-plunger_magnet_stickout-plunger_space_between_magnets+plunger_stickout;
plunger_cavity_height = probe_height-meat_above_magnet-magnet_thickness;
plunger_tolerance = 0.3;
plunger_magnet_tolerance = 0.6; // between magnet and inside of plunger wall

echo("plunger_width: ", plunger_width);
echo("plunger_length: ", plunger_length);

plunger_cavity_width = plunger_width+plunger_tolerance;
plunger_cavity_length = plunger_length+plunger_tolerance;

magnet_opening_bevel_height = 0.6;

screw_head_area_height = probe_height*0.6;

module probe_mount() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module probe_plunger() {
  module body() {
    hull() {
      translate([0,0,plunger_height/2]) {
        rounded_cube(plunger_length-plunger_tip_height*2,plunger_width-plunger_tip_height*2,plunger_height,2);
        translate([0,0,plunger_tip_height/2]) {
          rounded_cube(plunger_length,plunger_width,plunger_height-plunger_tip_height,3);
        }
      }
    }
  }

  module holes() {
    translate([0,0,plunger_height+1]) {
      translate([0,0,-magnet_thickness/2]) {
        % color("#ddd") hole(magnet_diam,magnet_thickness,resolution);
      }
      hole(magnet_cavity_diam,magnet_thickness*2,resolution);
    }

    translate([0,0,0]) {
    }
  }

  difference() {
    body();
    holes();
  }
}

module probe_body() {
  anti_elephant_foot = 0.5;
  module body() {
    hull() {
      translate([0,0,probe_height*0.75]) {
        rounded_cube(probe_length,probe_width,probe_height/2,probe_width);
      }
      translate([0,0,screw_head_area_height/2]) {
        rounded_cube(probe_length-anti_elephant_foot*2,probe_width-anti_elephant_foot*2,screw_head_area_height,3);
        translate([0,0,anti_elephant_foot/2]) {
          rounded_cube(probe_length,probe_width,screw_head_area_height-anti_elephant_foot*2,3);
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*magnet_spacing/2,0,probe_height]) {
        hole(magnet_cavity_diam,magnet_cavity_height*2,resolution);

        hull() {
          hole(magnet_cavity_diam,magnet_opening_bevel_height,resolution);
          translate([0,0,0.1]) {
            hole(magnet_cavity_diam+magnet_opening_bevel_height,0.2,resolution);
          }
        }

        translate([0,0,-magnet_thickness/2+magnet_stickout]) {
          % color("#ddd") hole(magnet_diam,magnet_thickness,resolution);
        }
      }
    }

    translate([0,0,-1]) {
      hull() {
        rounded_cube(plunger_cavity_length+anti_elephant_foot*2,plunger_cavity_width+anti_elephant_foot*2,2,1);
        rounded_cube(plunger_cavity_length,plunger_cavity_width,2+anti_elephant_foot*3,1);
        //hole(magnet_cavity_diam+plunger_magnet_tolerance,plunger_cavity_height*2,resolution);
      }
    }

    translate([0,0,probe_height-meat_above_magnet-magnet_thickness]) {
      translate([0,0,0]) {
        hole(magnet_cavity_diam,magnet_thickness*2,resolution);
        translate([0,0,magnet_thickness/2]) {
          % color("#ddd") hole(magnet_diam,magnet_thickness,resolution);
        }
      }
      translate([0,0,-0.4]) {
        // main plunger cavity
        translate([0,0,-plunger_cavity_height]) {
          rounded_cube(plunger_cavity_length,plunger_cavity_width,plunger_cavity_height*2,1);
          hole(magnet_cavity_diam+plunger_magnet_tolerance,plunger_cavity_height*2,resolution);
        }

        // bridging 
        intersection() {
          union() {
            cube([magnet_cavity_diam+plunger_magnet_tolerance,plunger_cavity_width,0.2*2*1],center=true);
            hole(magnet_cavity_diam+plunger_magnet_tolerance,0.2*2*2,8);
            hull() {
              hole(magnet_cavity_diam+plunger_magnet_tolerance,0.2*2*3,resolution);
              hole(magnet_cavity_diam,0.2*2*3+plunger_magnet_tolerance,resolution);
            }
          }
          union() {
            cube([plunger_cavity_length,plunger_cavity_width,plunger_cavity_height],center=true);
            hole(magnet_cavity_diam+plunger_magnet_tolerance,plunger_cavity_height*2,resolution);
          }
        }
      }
    }

    // debug
    if (1) {
      translate([0,front*probe_width/2,0]) {
        cube([probe_length*2,probe_width,probe_height*3],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module probe_assembly() {
  //translate([0,0,-probe_height]) {
  translate([0,0,0]) {
    probe_body();
  }
  translate([0,0,-plunger_stickout]) {
    probe_plunger();
  }
}

probe_assembly();
