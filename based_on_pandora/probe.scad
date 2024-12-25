include <./main.scad>;

m2_thread_into_plastic = 1.8;
m2_head_diam = 3.6;
m2_head_height = 2.5;
m2_diam = m2_thread_into_plastic;

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

echo("probe_width: ", probe_width);
echo("probe_length: ", probe_length);

//plunger_length = magnet_spacing-magnet_diam-wall_thickness*4;
plunger_length = min(magnet_spacing-magnet_diam-wall_thickness*4,10);
//plunger_width = probe_width-2*(extrude_width*4);
plunger_magnet_stickout = 0.6;
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
screw_pos_z = probe_height-meat_above_magnet-magnet_thickness-plunger_space_between_magnets-magnet_thickness-m2_diam/2;

magnet_ejection_hole_diam = 2;

probe_dock_tolerance = 0.5;
probe_extrusion_offset_y = -1;
probe_extrusion_offset_z = -5;

dock_wing_width = 1;
dock_wing_height = 1;
dock_wing_from_top = 1;
dock_wing_spacing = 4;
dock_height = probe_height;
dock_length = probe_length;
dock_width = probe_width+probe_dock_tolerance+dock_wing_width*2+3*2;
extrusion_mount_offset_x = magnet_spacing/2+dock_width/2-dock_length/2;
extrusion_mount_offset_y = probe_width/2+dock_wing_width+probe_dock_tolerance-probe_extrusion_offset_y+extrusion_side/2;

module probe_wings(width=probe_width,swell_by=0) {
  length = magnet_spacing-dock_wing_width;
  for(z=[0,-1]) {
    translate([0,0,probe_height-dock_wing_from_top-dock_wing_width-dock_wing_height/2+dock_wing_spacing*z]) {
      hull() {
        cube([length,width,dock_wing_height],center=true);
        //rounded_cube(magnet_spacing,probe_width,dock_wing_height,probe_width);
        rounded_cube(length,width+dock_wing_width*2+swell_by,dock_wing_height,width);
        rounded_cube(length,width,dock_wing_height+dock_wing_width*2+swell_by,width);
      }
    }
  }
}

module probe_dock() {
  extrusion_mount_anchor_width = wall_thickness*2;
  rounded_diam = extrusion_mount_anchor_width/2;

  mount_thickness = 5;

  bottom_of_extrusion_mount_pos_z = probe_height-probe_extrusion_offset_z;

  num_extrusion_anchors = 4;
  space_between_extrusion_mount_anchors = (dock_length-extrusion_mount_anchor_width*num_extrusion_anchors)/(num_extrusion_anchors-1);
  extrusion_mount_anchor_spacing = space_between_extrusion_mount_anchors+extrusion_mount_anchor_width;

  translate([extrusion_mount_offset_x,extrusion_mount_offset_y,bottom_of_extrusion_mount_pos_z]) {
    debug_axes(1);
  }
    
  module body() {
    hull() {
      translate([extrusion_mount_offset_x,0,0]) {
        translate([dock_length/2-dock_width/2,0,probe_height/2]) {
          cube([dock_width,1,probe_height],center=true);

          translate([0,dock_width/2-1,0]) {
            cube([dock_width,2,probe_height],center=true);
          }
        }
      }
      translate([0,0,probe_height-dock_height/2]) {
        translate([magnet_spacing/2,0,0]) {
          hole(dock_width,dock_height,resolution*2);

          translate([dock_width/2-probe_length+1,0,0]) {
            cube([2,dock_width,dock_height],center=true);
          }
        }
      }
      translate([probe_length/2+probe_dock_tolerance,0,screw_pos_z]) {
        rotate([0,90,0]) {
          hole(magnet_diam+4,magnet_thickness*2+wall_thickness*4,resolution);
        }
      }
    }
    translate([extrusion_mount_offset_x,0,0]) {
      translate([0,extrusion_mount_offset_y,probe_height-mount_thickness/2-probe_extrusion_offset_z]) {
        rounded_cube(probe_length,15,mount_thickness,rounded_diam);
      }
      translate([0,0,0]) {
        for(i=[0:num_extrusion_anchors-1]) {
          translate([-dock_length/2+extrusion_mount_anchor_width/2+i*(extrusion_mount_anchor_spacing),0,0]) {
            hull() {
              translate([0,probe_width/2+probe_dock_tolerance+5/2,probe_height/2]) {
                rounded_cube(extrusion_mount_anchor_width,5,probe_height,extrusion_mount_anchor_width/2);
              }
              translate([0,extrusion_mount_offset_y,bottom_of_extrusion_mount_pos_z-mount_thickness-0.1]) {
                rounded_cube(extrusion_mount_anchor_width,15,0.2,extrusion_mount_anchor_width/2);
              }
            }
            
          }
        }
      }
    }
  }

  module holes() {
    rounded_cube(probe_length+probe_dock_tolerance,probe_width+probe_dock_tolerance,probe_height*3,probe_width+probe_dock_tolerance);

    probe_wings(probe_width+probe_dock_tolerance,probe_dock_tolerance);
    translate([-probe_length*0.4,0,0]) {
      probe_wings(probe_width+probe_dock_tolerance,probe_dock_tolerance);
    }

    translate([extrusion_mount_offset_x-dock_length/2+extrusion_mount_anchor_width/2,extrusion_mount_offset_y,bottom_of_extrusion_mount_pos_z-mount_thickness]) {
      //for(x=[left,0,right]) {
      for(i=[0:num_extrusion_anchors-2]) {
        translate([(i+0.5)*(extrusion_mount_anchor_spacing),0,0]) {
          translate([x*(dock_length*0.33),0,0]) {
            extrusion_mount_hole_diam = m3_through_hole_diam;
            hole(extrusion_mount_hole_diam,probe_height*4,resolution);

            // allow holes to bridge 
            cube([space_between_extrusion_mount_anchors,extrusion_mount_hole_diam,0.2*2*1],center=true);
            cube([extrusion_mount_hole_diam,extrusion_mount_hole_diam,0.2*2*2],center=true);
            hole(extrusion_mount_hole_diam,0.2*2*3,8);
          }
        }
      }
    }

    translate([probe_length/2+probe_dock_tolerance,0,screw_pos_z]) {
      rotate([0,90,0]) {
        hole(magnet_cavity_diam,(magnet_cavity_height+0.5)*2,8);
        translate([0,0,magnet_thickness/2]) {
          % color("#ddd") hole(magnet_diam,magnet_thickness,resolution);
        }
      }
    }

    // for debug
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
          rounded_cube(plunger_length,plunger_width,plunger_height-plunger_tip_height,1);
        }
      }
    }
  }

  module holes() {
    translate([0,0,plunger_height+plunger_magnet_stickout]) {
      translate([0,0,-magnet_thickness/2]) {
        % color("#ddd") hole(magnet_diam,magnet_thickness,resolution);
      }
      translate([0,0,-magnet_thickness+0.6]) {
        screw_hole_width = 2.3;
        screw_hole_height = plunger_height-plunger_tip_height-magnet_thickness;
        translate([0,0,-screw_hole_height/2]) {
          rotate([0,90,0]) {
            rounded_cube(screw_hole_height,screw_hole_width,plunger_length*3,screw_hole_width,8);
          }
        }
      }
      hole(magnet_cavity_diam,magnet_thickness*2,resolution);
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
        rounded_cube(probe_length,probe_width,probe_height/2,probe_width,resolution*2);
      }
      translate([0,0,screw_head_area_height/2]) {
        //rounded_diam = 3;
        rounded_diam = probe_width;
        rounded_cube(probe_length-anti_elephant_foot*2,probe_width-anti_elephant_foot*2,screw_head_area_height,rounded_diam-anti_elephant_foot*2,resolution*2);
        translate([0,0,anti_elephant_foot/2]) {
          rounded_cube(probe_length,probe_width,screw_head_area_height-anti_elephant_foot*2,rounded_diam,resolution*2);
        }
      }
    }

    probe_wings();
  }

  module holes() {
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        // magnets
        translate([magnet_spacing/2,0,0]) {
          translate([0,0,probe_height]) {
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

          // spring cavity
          translate([0,0,screw_pos_z-m2_head_diam/2]) {
            translate([0,0,probe_height/2]) {
              hole(spring_cavity_diam,probe_height,resolution);
            }
          }

          // be able to eject the magnets
          hole(magnet_ejection_hole_diam,probe_height*2,resolution);
        }


        // screw holes
        translate([probe_length/2,0,screw_pos_z]) {
          rotate([0,90,0]) {
            translate([0,0,-m2_head_height+probe_length/2]) {
              hole(m2_head_diam,probe_length,resolution);
              hole(m2_diam,probe_length*2,resolution);
            }
          }
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

    // be able to eject middle magnet
    translate([0,0,probe_height-meat_above_magnet]) {
      intersection() {
        union() {
          hole(magnet_ejection_hole_diam,probe_height,resolution);
          cube([magnet_ejection_hole_diam,probe_width,0.2*2*1],center=true);
          cube([magnet_ejection_hole_diam,magnet_ejection_hole_diam,0.2*2*2],center=true);
          //hole(magnet_ejection_hole_diam,0.2*2*3,8);
        }

        hole(magnet_cavity_diam,probe_height,resolution);
      }
    }

    // for debug
    if (0) {
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
  translate([0,-extrusion_mount_offset_y,-probe_height+probe_extrusion_offset_z]) {
    translate([0,0,0]) {
      probe_body();
    }
    translate([0,0,-plunger_stickout]) {
      probe_plunger();
    }

    probe_dock();
  }

  translate([0,0,extrusion_side/2]) {
    rotate([0,90,0]) {
      % extrusion_l(60);
    }
  }

  // probably don't need; planning on using integrated dragon burner mount
  translate([0,0,probe_height+magnet_stickout]) {
    //probe_mount();
  }
}

probe_assembly();
