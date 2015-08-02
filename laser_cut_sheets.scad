include <config.scad>;
include <positions.scad>;
use <main.scad>;

laser_cutter_width = 609;
laser_cutter_depth = 457;

module sides_and_top() {
  for(side=[left,right]) {
    translate([side*(side_sheet_height/2+1),side_sheet_depth/2+sheet_thickness+1,0]) {
      rotate([0,0,90*side]) {
        side_sheet();
      }

      if (side == left) {
        translate([top_sheet_pos_z/2*-side,0,0]) {
          z_main_plate();
        }
      }
    }
  }

  translate([0,-top_sheet_depth/2-sheet_thickness-1,0]) {
    translate([left*(top_sheet_width/2+sheet_thickness+1),0,0]) {
      rotate([0,0,0]) {
        top_sheet();
      }

      translate([0,-11,0]) {
        rotate([0,0,180]) {
          z_bed_plate();
        }
      }
    }

    translate([right*(top_sheet_width/2+sheet_thickness+1),0,0]) {
      rotate([0,0,0]) {
        bottom_sheet();
      }
    }
  }

  % cube([609,457,1],center=true);
}

module front_back_and_other() {
  translate([0,laser_cutter_depth/2-sheet_height/2-sheet_thickness*3,0]) {
    translate([left*(front_sheet_width/2+sheet_thickness*2),0,0]) {
      rotate([0,0,180]) {
        front_sheet();
      }

      for(side=[left,right]) {
        mirror([1-side,0,0]) {
          translate([z_printed_portion_height/2+sheet_thickness+2,-side_sheet_height/2+main_opening_height-z_build_platform_depth*.75,0]) {
            rotate([0,0,90]) {
              z_support_arm();
            }
          }
        }
      }
    }
    translate([right*(front_sheet_width/2+sheet_thickness*2),0,0]) {
      translate([0,sheet_thickness+bc_shoulder_width,0]) {
        rotate([0,180,0]) {
          rear_sheet();
        }
      }

      translate([0,-sheet_height/2-top_rear_brace_depth-5]) {
        rotate([0,0,180]) {
          z_brace_sheet();
        }
      }
    }
  }
  translate([left*(front_sheet_width/2+sheet_thickness*2),0,0]) {
    rotate([0,0,90]) {
      //# handle();
    }
  }

  % cube([609,457,1],center=true);
}

translate([0,laser_cutter_depth/2+10,0]) {
  sides_and_top();
}

translate([0,-laser_cutter_depth/2-10,0]) {
  front_back_and_other();
}
