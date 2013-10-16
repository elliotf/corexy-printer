include <main.scad>;
use <lib/boxcutter/main.scad>;

module more_lasercut() {
  motor_wire_hole_height = 6;

  sheet_shoulder_width = 3;

  top_sheet_opening_width = build_x+x_carriage_width;
  top_sheet_opening_depth = build_y+x_carriage_depth;

  xy_motor_x = y_rod_x;

  top_sheet_width = top_sheet_opening_width+motor_side*2+sheet_thickness*2+sheet_shoulder_width*2;
  top_sheet_width = (xy_motor_x+motor_side/2+spacer+sheet_thickness+sheet_shoulder_width)*2;
  top_sheet_width = (xy_motor_x+motor_side/2+spacer)*2;
  top_sheet_width = (y_rod_x+motor_side)*2;
  top_sheet_depth = top_sheet_opening_depth+motor_side+sheet_thickness*2+sheet_shoulder_width*2;

  rod_z = -belt_bearing_diam/2-belt_bearing_thickness/2-belt_bearing_nut_thickness-spacer;
  y_rod_z = rod_z;
  x_rod_z = y_rod_z;

  rear_sheet_y = top_sheet_opening_depth/2+sheet_shoulder_width+sheet_thickness/2;

  xy_idler_z = rod_z+belt_bearing_diam/2;

  front_idler_x = xy_idler_x+belt_bearing_diam/2;
  front_idler_y = -top_sheet_opening_depth/2-belt_bearing_diam/2;
  front_idler_z = y_rod_z;

  to_motor_idler_x = xy_motor_x-pulley_diam/2;
  to_motor_idler_y = rear_sheet_y-belt_bearing_diam/2+sheet_thickness/2+spacer;
  to_motor_idler_z = front_idler_z-belt_bearing_diam*1.25;

  return_idler_x = front_idler_x;
  return_idler_y = rear_sheet_y-belt_bearing_diam/2+sheet_thickness/2+belt_bearing_diam+spacer;
  return_idler_z = xy_idler_z;

  xy_motor_y = top_sheet_opening_depth/2+sheet_shoulder_width;
  xy_motor_y = top_sheet_opening_depth/2+sheet_shoulder_width+sheet_thickness+motor_side/2;
  xy_motor_z = to_motor_idler_z-belt_bearing_diam/2-spacer*2-motor_side/2;

  rear_sheet_width = top_sheet_width;
  rear_sheet_height = xy_motor_z*-1+motor_side/2+spacer*4;
  rear_sheet_z = -rear_sheet_height/2;

  front_sheet_height = rear_sheet_height;
  front_sheet_width = top_sheet_width;
  front_sheet_y = -top_sheet_opening_depth/2-sheet_shoulder_width-sheet_thickness/2;
  front_sheet_y = front_idler_y-belt_bearing_diam/2-spacer-sheet_thickness/2;
  front_sheet_z = -front_sheet_height/2;

  side_sheet_depth = -front_sheet_y+rear_sheet_y-sheet_thickness;
  side_sheet_height = rear_sheet_height;
  side_sheet_x = y_rod_x+motor_side+sheet_thickness/2;
  side_sheet_y = (rear_sheet_y+front_sheet_y)/2;
  side_sheet_z = -side_sheet_height/2;

  y_rod_len = rear_sheet_y+(-1*front_sheet_y)+sheet_thickness;
  y_rod_y = side_sheet_y;

  //pulley_height = belt_bearing_diam;
  //pulley_height = 10;

  motor_idler_dist = abs(xy_motor_z) - abs(xy_idler_z) - pulley_diam/3;
  short = motor_idler_dist;
  short = (belt_bearing_diam+pulley_height);
  long  = (xy_motor_x)*2;
  long  = front_idler_x*2;
  echo("SHORT (ADJACENT): ", short);
  echo("LONG (OPPOSITE): ", long);
  return_idler_angle = atan(long/short);
  echo("ANGLE: ", return_idler_angle);

  debug_len = 1000;
  debug_len = 0;

  for(side=[left,right]) {
    translate([y_rod_x*side,0,rod_z]) {
      translate([0,y_rod_y,0]) rotate([90,0,0])
        color("grey", .6) cylinder(r=rod_diam/2,h=y_rod_len,center=true);
      mirror([side+1,0,0]) y_carriage();
    }
  }

  // build volume
  % translate([0,0,z_rod_z+sheet_thickness])
    cube([build_x,build_y,build_z],center=true);

  module z_axis() {
    //z_threaded_rod_len = build_z+y_rod_z-motor_shaft_len-bearing_diam;
    sheet_to_threaded_rod_dist = (y_rod_z - bearing_diam/2 - spacer)*-1;
    smooth_threaded_dist_x = motor_side/2-rod_diam/2;

    bearing_wrapper_thickness = min_material_thickness*1.5;

    carriage_width = bearing_wrapper_thickness + bearing_diam/2 + smooth_threaded_dist_x + m3_nut_diam/2 + min_material_thickness*2;
    carriage_width = (bearing_wrapper_thickness + bearing_diam/2 + smooth_threaded_dist_x/2)*2;
    carriage_width = (5/2+smooth_threaded_dist_x+bearing_diam/2+bearing_wrapper_thickness)*2;
    carriage_width = (smooth_threaded_dist_x+bearing_diam/2+bearing_wrapper_thickness)*2;
    carriage_width = (smooth_threaded_dist_x+bearing_diam/2+bearing_wrapper_thickness)*2;
    carriage_depth = bearing_diam/2+min_material_thickness*2;
    carriage_depth = m5_nut_thickness+min_material_thickness*2;
    carriage_height = bearing_len*2+min_material_thickness*3;

    bolt_area_depth = carriage_depth*2+bearing_diam;
    bolt_area_thickness = m5_nut_thickness+min_material_thickness*2;

    z_threaded_rod_len = build_z+5+carriage_height;
    z_threaded_rod_z = -sheet_to_threaded_rod_dist - z_threaded_rod_len/2;
    z_rod_len = z_threaded_rod_len + sheet_thickness + spacer + motor_shaft_len + sheet_to_threaded_rod_dist;

    z_rod_x = (top_sheet_width/2 - spacer*2 - zip_tie_thickness - bearing_diam/2);
    z_rod_x = y_rod_x+bearing_diam/2+rod_diam;
    z_rod_z = -z_rod_len/2+sheet_thickness;
    z_motor_x = z_rod_x-smooth_threaded_dist_x;

    support_slot_height = carriage_height/4;
    support_slot_len = carriage_width/2+sheet_thickness;
    support_slot_len = carriage_width/4+sheet_thickness;
    support_slots = [carriage_height/2-carriage_height/8,-carriage_height/4+carriage_height/8];

    // in relation to the motor plate
    carriage_x = -smooth_threaded_dist_x/2+(carriage_width-smooth_threaded_dist_x)/2-bearing_diam/2;
    carriage_x = -smooth_threaded_dist_x/2;
    carriage_x = 0;
    carriage_y = bearing_diam/2+carriage_depth/2;

    // prusa i3 rip-off z axis

    captive_nut_body_height = m5_nut_thickness+min_material_thickness*2;
    captive_nut_body_diam = m5_nut_diam+min_material_thickness*2;

    x_support_y = carriage_y+carriage_depth/2+sheet_thickness/2;
    x_support_len = (z_rod_x-smooth_threaded_dist_x-carriage_width*.2)*2;
    x_support_len = (z_rod_x-carriage_width+bolt_area_thickness+bearing_diam)*2;
    x_support_len = (z_rod_x-carriage_width/2)*2;
    x_support_len = z_motor_x*2-carriage_width+support_slot_len*2;
    y_support_x = (x_support_len-support_slot_len*2)/2+sheet_thickness/2;
    y_support_x = z_motor_x-carriage_width/2-sheet_thickness/2;
    y_support_len = build_y;
    top_support_width = y_support_x*2+sheet_thickness*2+3*2;
    top_support_depth = heatbed_depth+3*3;

    echo("z_threaded_rod_len: ", z_threaded_rod_len);

    module body() {
      // main body back
      translate([carriage_x,carriage_y,0])
        cube([carriage_width,carriage_depth,carriage_height],center=true);

      // bolt area
      translate([carriage_width/2-bolt_area_thickness/2,0,0])
        cube([bolt_area_thickness,bolt_area_depth,carriage_height],center=true);

      // prusa-style bearing holder
      translate([-smooth_threaded_dist_x,bearing_diam/2,0])
        cube([bearing_diam+bearing_wrapper_thickness*2,bearing_diam,carriage_height],center=true);
      translate([-smooth_threaded_dist_x,0,0])
        hole(bearing_diam+bearing_wrapper_thickness*2,carriage_height,36);

      // captive nut
      translate([0,0,carriage_height/2-captive_nut_body_height/2]) {
        hull() {
          translate([carriage_width/2-bolt_area_thickness/2,0,0])
            cube([bolt_area_thickness,bolt_area_depth,captive_nut_body_height],center=true);
          translate([-smooth_threaded_dist_x,bolt_area_depth/4,0])
            cube([1,bolt_area_depth/2,captive_nut_body_height],center=true);
        }
      }
    }

    module holes() {
      long = carriage_width-bearing_wrapper_thickness-bearing_diam/2-bolt_area_thickness;
      short = bolt_area_depth/2;
      bearing_holder_gap_angle = atan(short/long);

      // prusa-style bearing holder
      translate([-smooth_threaded_dist_x,0,0]) {
        hole(bearing_diam,carriage_height+1,36);

        rotate([0,0,-bearing_holder_gap_angle])
          translate([carriage_width/2,0,0])
            cube([carriage_width,spacer,carriage_height+1],center=true);
      }

      // z rod captive nut
      translate([0,0,carriage_height/2-captive_nut_body_height])
        rotate([0,0,90])
          hole(m5_nut_diam,m5_nut_thickness*2,6);

      // z threaded rod
      cylinder(r=m5_nut_diam/2-.5,h=carriage_height+1,center=true,$fn=6);

      // x axis support bolts
      translate([carriage_width/2-bolt_area_thickness-m5_nut_diam/2,carriage_y,0]) {
        for(z=support_slots) {
          translate([0,0,z*-1]) {
            rotate([90,0,0]) hole(5,carriage_depth+1,6);

            translate([0,-carriage_depth/2,0])
              rotate([90,0,0]) hole(m5_nut_diam,m5_nut_thickness*1.5,6);
          }
        }
      }

      // y axis support bolts
      translate([carriage_width/2-bolt_area_thickness/2,-bolt_area_depth/4,0]) {
        for(z=support_slots) {
          translate([0,0,z*-1]) {
            rotate([0,90,0]) rotate([0,0,90]) hole(5,carriage_depth+1,6);

            translate([-bolt_area_thickness/2,0,0])
              rotate([0,90,0]) rotate([0,0,90]) hole(m5_nut_diam,m5_nut_thickness*1.5,6);
          }
        }
      }
    }

    module plastic_carriage() {
      difference() {
        body();
        holes();
      }
    }

    translate([0,0,-z_rod_len+carriage_height/2+sheet_thickness+spacer]) {
      // x support
      % translate([0,x_support_y,0]) {
        difference() {
          cube([x_support_len,sheet_thickness,carriage_height],center=true);

          for(side=[left,right]) {
            for(z=support_slots) {
              translate([x_support_len/2*side,0,z]) {
                cube([support_slot_len*2,sheet_thickness+1,support_slot_height],center=true);
              }

              translate([(y_support_x+sheet_thickness/2+bolt_area_thickness+m5_nut_diam/2)*side,0,z*-1]) {
                rotate([90,0,0]) hole(5,sheet_thickness+1,16);
              }
            }
          }
        }
      }

      // y support
      % for(side=[left,right]) {
        translate([y_support_x*side,0,0]) {
          difference() {
            cube([sheet_thickness,y_support_len,carriage_height],center=true);

            for(z=support_slots) {
              translate([0,x_support_y,z*-1]) {
                cube([sheet_thickness+1,sheet_thickness,support_slot_height],center=true);
              }

              translate([0,-bolt_area_depth/4,z*-1]) {
                rotate([0,90,0]) hole(5,sheet_thickness+1,16);
              }
            }
          }
        }
      }

      // support plate
      translate([0,0,carriage_height/2+sheet_thickness/2]) {
        % cube([top_support_width,top_support_depth,sheet_thickness],center=true);

        color("red") translate([0,0,sheet_thickness/2]) heatbed();
      }
    }



    for(side=[left,right]) {
      translate([z_rod_x*side,0,z_rod_z])
        % cylinder(r=rod_diam/2,h=z_rod_len,center=true);

      translate([z_motor_x*side,0,z_threaded_rod_z]) {
        % cylinder(r=5/2,h=z_threaded_rod_len,center=true);

        translate([0,0,-z_threaded_rod_len/2-spacer-motor_shaft_len]) {
          % color("blue", .5) motor();

          mirror([side+1,0,0]) {
            translate([0,0,carriage_height/2+spacer]) {
              plastic_carriage();

              /*
              //translate([carriage_x,carriage_y,0]) cube([carriage_width,carriage_depth,carriage_height],center=true);

              for(z=[-1,1]) {
                % translate([-smooth_threaded_dist_x,0,(bearing_len/2+min_material_thickness/2)*z])
                  rotate([90,0,0]) bearing_with_zip_tie();
              }
              */
            }
          }
        }
      }

        /*
        translate([0,0,-build_z/2]) {
          for(side=[left,right]) {
            translate([z_rod_x*side,0,0]) {
              cylinder(r=rod_diam/2,h=build_z,center=true);
              rotate([90,0,0]) bearing();
            }
          }
        }

        for(side=[left,right]) {
          translate([z_rod_x*side,0,0]) {
            cylinder(r=rod_diam/2,h=build_z,center=true);
            rotate([90,0,0]) bearing();
          }
        }
      }
        */
    }

    /*
    translate([0,0,-build_z/2+sheet_thickness]) {
      for(side=[left,right]) {
        translate([z_rod_x*side,0,0]) {
          cylinder(r=rod_diam/2,h=build_z,center=true);
          rotate([90,0,0]) bearing();
        }
        translate([(z_rod_x-motor_side/2)*side,0,-build_z/2]) {
          motor();

          translate([0,0,motor_shaft_len+1+z_threaded_rod_len/2])
            cylinder(r=5/2,h=z_threaded_rod_len,center=true);
        }
      }
    }
    */
  }

  z_axis();

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

    //translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();
    translate([y_rod_x*left,front_idler_y,xy_idler_z]) rotate([0,0,0]) idler_bearing();

    /*
    // front to motor idler
    hull() {
      translate([front_idler_x*left,front_idler_y,xy_idler_z-belt_bearing_diam]) dot();
      translate([to_motor_idler_x*left,to_motor_idler_y,to_motor_idler_z+belt_bearing_diam/2]) dot();
    }

    translate([to_motor_idler_x*left,to_motor_idler_y,to_motor_idler_z]) rotate([0,90,0]) idler_bearing();

    // motor idler to pulley
    hull() {
      translate([to_motor_idler_x*left,to_motor_idler_y+belt_bearing_diam/2,to_motor_idler_z]) dot();
      //translate([(xy_motor_x-pulley_diam/2)*left,xy_motor_y+pulley_height/2,xy_motor_z]) dot();
      translate([(xy_motor_x-pulley_diam/2)*left,to_motor_idler_y+belt_bearing_diam/2,xy_motor_z]) dot();
    }
    */

    /*
    translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) {
      rotate([-90,0,0])
        motor_with_pulley();
    }
    */

    // front to motor
    hull() {
      translate([(y_rod_x+belt_bearing_diam/2)*left,front_idler_y,xy_idler_z]) dot();
      translate([(y_rod_x+belt_bearing_diam/2)*left,xy_motor_y,xy_idler_z-pulley_height]) dot();
    }

    /*
    // front to motor
    hull() {
      translate([front_idler_x*left,front_idler_y,xy_idler_z-belt_bearing_diam]) dot();
      translate([front_idler_x*left,xy_motor_y,front_idler_z-belt_bearing_diam/2]) dot();
    }

    //translate([-front_idler_x,rear_sheet_y+sheet_thickness/2+motor_side/2,front_idler_z-belt_bearing_diam/2]) {
    translate([-front_idler_x,rear_sheet_y+sheet_thickness/2+motor_side/2,front_idler_z-belt_bearing_diam/2]) {
      rotate([0,return_idler_angle-90,0]) {
        # cube([1,10,1],center=true);
        translate([-pulley_diam/2,0,-xy_pulley_above_motor_plate-pulley_height/2])
          motor_with_pulley();
      }
    }
    */

    translate([(y_rod_x+belt_bearing_diam/2+pulley_diam/2)*left,rear_sheet_y+sheet_thickness/2+motor_side/2,xy_idler_z-pulley_height/2-xy_pulley_above_motor_plate]) {
      motor_with_pulley();
    }

    // pulley to return idler
    hull() {
      translate([(y_rod_x+belt_bearing_diam/2+pulley_diam/2)*left,xy_motor_y-pulley_diam/2,xy_idler_z]) dot();
      translate([(return_idler_x-belt_bearing_diam/2)*right,return_idler_y+belt_bearing_diam/2,return_idler_z]) dot();
    }

    translate([(return_idler_x-belt_bearing_diam/2)*right,return_idler_y*rear,return_idler_z]) idler_bearing();

    /*
    // pulley to return idler
    hull() {
      //translate([xy_motor_x*left,xy_motor_y+pulley_height*1.5,xy_motor_z+pulley_diam/2]) dot();
      translate([front_idler_x*left,xy_motor_y-pulley_diam/2,front_idler_z-belt_bearing_diam/2-pulley_height]) dot();
      //translate([xy_motor_x*left,to_motor_idler_y+belt_bearing_diam/2+pulley_height,xy_motor_z+pulley_diam/2]) dot();
      translate([(return_idler_x-belt_bearing_diam/2)*right,return_idler_y+belt_bearing_diam/2,return_idler_z-belt_bearing_thickness/3]) dot();
    }

    translate([return_idler_x*right,return_idler_y,return_idler_z])
      rotate([0,return_idler_angle*right,0]) {
        translate([0,0,-belt_bearing_diam/2]) rotate([0,90,0])
          idler_bearing();
        # translate([0,0,-debug_len/2]) cylinder(r=1,h=debug_len,center=true);
      }
    */

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
  color("red", 0.6) mirror([1,0,0]) line(1);

  color("grey", .3) {

    // top sheet
    translate([0,0,sheet_thickness/2]) difference() {
      translate([0,side_sheet_y,0]) {
        union() {
          box_side([front_sheet_width,side_sheet_depth],[2,2,1,2]);
          // avoid too-thin top sheet
          translate([0,side_sheet_depth/2+sheet_thickness+3+belt_bearing_diam/2,0])
            cube([top_sheet_width+sheet_thickness*2+3*2,belt_bearing_diam,sheet_thickness],center=true);
        }
      }
      //cube([top_sheet_width,top_sheet_depth,sheet_thickness],center=true);
      cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);
    }

  /*
    // front sheet
    translate([0,front_sheet_y,front_sheet_z]) rotate([90,0,0]) difference() {
      box_side([front_sheet_width,front_sheet_height],[2,2,0,2]);

      translate([0,-front_sheet_z,0]) {
        for(side=[left,right]) {
          // y rods
          translate([y_rod_x*side,y_rod_z,0])
            hole(rod_diam,sheet_thickness+1,32);
        }
      }
    }

    // rear sheet
    translate([0,rear_sheet_y,rear_sheet_z]) rotate([90,0,0]) difference() {
      box_side([front_sheet_width,front_sheet_height],[1,2,0,2]);
      //cube([rear_sheet_width,rear_sheet_height,sheet_thickness],center=true);

      translate([0,-rear_sheet_z,0]) {
        for(side=[left,right]) {
          // holes for "to motor" idler
          translate([front_idler_x*side,front_idler_z-belt_bearing_diam,0]) {
            hull() {
              for(offset=[-1,1]) {
                translate([0,belt_bearing_diam/2*offset,0])
                  cylinder(r=3,h=sheet_thickness+1,center=true,$fn=16);
              }
            }
          }

          // line hole for "return" idler
          translate([front_idler_x*side,xy_idler_z,0])
            hole(4,sheet_thickness+1,16);

          // y rods
          translate([y_rod_x*side,y_rod_z,0])
            hole(rod_diam,sheet_thickness+1,32);
        }
      }
    }

    // side sheets
    for(side=[left,right]) {
      translate([side_sheet_x*side,side_sheet_y,side_sheet_z]) rotate([90,0,90]) {
        //cube([side_sheet_depth,side_sheet_height,sheet_thickness],center=true);
        box_side([side_sheet_depth,side_sheet_height],[1,1,0,1]);
      }
    }
  */
  }
}

more_lasercut();
