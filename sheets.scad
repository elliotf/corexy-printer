include <config.scad>;
include <positions.scad>;
use <main.scad>;

laser_cutter_width = 609;
laser_cutter_depth = 457;

module sides_and_top() {
  translate([-laser_cutter_width/2+sheet_thickness*3+sheet_height,0,0]) {
    for(side=[left,right]) {
      translate([(side_sheet_height/2+1)*side,side_sheet_depth/2+sheet_thickness+1,0]) {
        rotate([0,0,90*side]) {
          side_sheet();
        }
      }
    }

    translate([left*(top_sheet_width/2+sheet_thickness+1),-top_sheet_depth/2-sheet_thickness,0]) {
      rotate([0,0,0]) {
        top_sheet();
      }
    }

    translate([right*(top_sheet_width/2+sheet_thickness+1),-top_sheet_depth/2-sheet_thickness,0]) {
      rotate([0,0,0]) {
        bottom_sheet();
      }
    }
  }

  % cube([609,457,1],center=true);
}

module front_back_and_other() {
  translate([-laser_cutter_width/2+front_sheet_width+sheet_thickness*5,laser_cutter_depth/2-sheet_height/2-sheet_thickness*3,0]) {
    translate([left*(front_sheet_width/2+sheet_thickness*2),0,0]) {
      rotate([0,0,180]) {
        front_sheet();
      }
    }
    translate([right*(front_sheet_width/2+sheet_thickness*2),0,0]) {
      rotate([0,0,180]) {
        rear_sheet();
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
  projection(cut=true) sides_and_top();
}

translate([0,-laser_cutter_depth/2-10,0]) {
  projection(cut=true) front_back_and_other();
}
