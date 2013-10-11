include <main.scad>;

y_rod_len = 236;
endstop = 1;
pulley_box_width = 72;
pulley_box_len = y_rod_len+sheet_min_width+motor_side;
pulley_box_side_height = 40;

abs_min_sheet_width = 3;
side_x = left*(pulley_box_width/2-sheet_thickness/2-abs_min_sheet_width);
side_z = -sheet_thickness-pulley_box_side_height/2;

//% translate([0,y_rod_len/2*front,y_rod_z]) y_end_front(endstop);
//% translate([0,y_rod_len/2*rear,y_rod_z]) y_end_rear(endstop);

motor_rod_spacing = motor_side/2+sheet_thickness/2 + spacer;

module tabs_to_fill(to_fill=200,neg=0,tab_dim=[10,sheet_thickness+0.05,sheet_thickness+0.05],space_between=25) {
  space_avail = to_fill+space_between;

  space_between_tab_pair = 15;
  tab_set_space = tab_dim[0]*2+space_between_tab_pair;

  num_fit = floor(space_avail/(tab_set_space+space_between));
  echo(space_avail, "/", tab_set_space, "+", space_between, "=", num_fit);

  space_taken_by_fit = (tab_set_space+space_between)*(num_fit-1) + tab_set_space;
  space_left_over = to_fill-space_taken_by_fit;
  echo(to_fill, "(to fill) - ", space_taken_by_fit, "(space taken by fit) = ", space_left_over, "(space left over)");

  echo("NUM FIT: ", num_fit);
  echo("LEFT OVER: ", space_left_over);

  add_to_each_space_between = space_left_over/(num_fit-1);
  spacer = space_between + add_to_each_space_between;

  echo("SPACER: ", spacer);

  module tab_set() {
    tab_width = tab_dim[0];

    translate([tab_width/2,0,0])
      cube(tab_dim,center=true);

    translate([tab_width*1.5+space_between_tab_pair,0,0])
      cube(tab_dim,center=true);
  }

  translate([-to_fill/2,0,tab_dim[2]/2]) {
    for(i=[0:num_fit-1]) {
      translate([i*(tab_set_space+spacer),0,0]) {
        tab_set();
      }
    }
  }
}

/*
fill_distance = 300;
translate([0,0,-5]) cube([fill_distance,sheet_thickness,10],center=true);
tabs_to_fill(fill_distance);
translate([-fill_distance/2+35/2,-10,0]) cube([35,2,2],center=true);
translate([0,-12,0]) cube([30,2,2],center=true);
*/

module pulley_box_top() {
  difference() {
    translate([0,motor_side/4,0])
      cube([pulley_box_width,pulley_box_len,sheet_thickness],center=true);

    translate([2,0,0]) {
      // y ends
      translate([-motor_rod_spacing/2,0,0]) {
        translate([0,y_rod_len/2*front,0]) y_end_front_screw_holes();
        translate([0,y_rod_len/2*rear,0]) y_end_rear_screw_holes();
      }


      // motor holes
      translate([motor_rod_spacing/2,xy_motor_y*rear,0]) {
        cylinder(r=motor_hole_spacing/2,h=sheet_thickness+1,center=true);
        for(motor_side=[left,right]) {
          for(motor_end=[front,rear]) {
            translate([motor_hole_spacing/2*motor_side,motor_hole_spacing/2*motor_end,0])
              cylinder(r=motor_screw_diam*da6,h=sheet_thickness+1,center=true,$fn=6);
          }
        }
      }
    }

    translate([side_x,motor_side/4,-sheet_thickness/2]) rotate([0,0,90]) tabs_to_fill(pulley_box_len-15);
  }
}

module pulley_box_side() {
  cube([sheet_thickness,pulley_box_len,pulley_box_side_height],center=true);
  translate([0,0,pulley_box_side_height/2]) rotate([0,0,90]) tabs_to_fill(pulley_box_len-15);
}

module assembly() {
  //pulley_box_top();
  translate([side_x,motor_side/4,side_z]) pulley_box_side();
}

module plate() {
  translate([-pulley_box_width/2,0,0]) pulley_box_top();
  translate([pulley_box_side_height/2+5,motor_side/4,0]) rotate([0,90,0]) pulley_box_side();

}

//projection() {
//  pulley_box_top();
//}
projection(cut=true) plate();
//assembly();
