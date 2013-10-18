include <config.scad>;
use <util.scad>;

cylinder_resolution = 18;
cylinder_resolution = 90;
motor_shaft_diam = 5;
idler_bearing_diam = 16;
idler_diam = idler_bearing_diam + min_material_thickness*2;
idler_bearing_thickness = 4;
idler_bearing_thickness = 5;
add_shaft_len = m3_nut_diam;
groove_height = 0.5;
groove_spacing = 1;
num_pulley_grooves = 7;

function get_grooved_height(num_grooves) = groove_spacing*(num_grooves+1)+groove_height*num_grooves;

module grooves(diam,num_grooves) {
  //height = groove_spacing*(num_grooves+1)+groove_height*num_grooves;
  height = get_grooved_height(num_grooves);

  % cube([diam*2,groove_height,groove_height],center=true);
  first_to_last_groove_dist = (num_grooves-1)*(groove_spacing+groove_height);
  echo("MOTOR PULLEY FIRST TO LAST GROOVE DIST: ", first_to_last_groove_dist);
  % translate([pulley_diam/2+2,0,0]) cube([1,1,first_to_last_groove_dist],center=true);

  module pulley_ridge() {
    rotate_extrude($fn=cylinder_resolution)
      translate([diam/2,0,0])
        scale([.6,groove_spacing*.85])
          rotate(90)
            circle(accurate_diam(1,6),$fn=6);
  }

  translate([0,0,-height/2+groove_spacing/2]) {
    for(z=[0:num_grooves]) {
      translate([0,0,(groove_height+groove_spacing)*z])
        pulley_ridge();
    }
  }
}

module motor_pulley(num_grooves) {
  grooved_height = get_grooved_height(num_grooves);
  add_shaft_len = m3_nut_diam;
  height = grooved_height + add_shaft_len;

  echo("MOTOR PULLEY HEIGHT: ", height);
  echo("MOTOR PULLEY GROOVE HEIGHT: ", grooved_height);

  collar_height = add_shaft_len + groove_spacing/2;
  collar_diam = pulley_diam+min_material_thickness*2;
  echo("COLLAR HEIGHT: ", collar_height);
  translate([0,0,collar_height/2]) cube([0,0,0],center=true);

  module body() {
    cylinder(r=pulley_diam/2,h=height,center=true,$fn=cylinder_resolution);
    translate([0,0,-height/2+collar_height/2])
      cylinder(r=collar_diam/2,h=collar_height,center=true,$fn=cylinder_resolution);
  }

  module holes() {
    difference() {
      hole(motor_shaft_diam+0.1,100,12);
      translate([0,2.65,0]) cube([motor_shaft_diam,1,height*2],center=true);
    }

    /*
    // attempt to make pulley printable upside down
    translate([0,0,-height/2+collar_height-1.5])
      rotate_extrude($fn=cylinder_resolution)
        translate([collar_diam/2,0,0])
          rotate(45)
            square([2.5,2.5]);
    */

    captive_nut_hole_len = 2.15+m3_nut_thickness;
    translate([0,0,-height/2+collar_height/2]) {
      translate([0,pulley_diam/2,0]) rotate([90,0,0]) hole(m3_diam,pulley_diam,6);
      //# translate([0,2.15+m3_nut_thickness/2,0]) rotate([90,0,0]) rotate([0,0,90]) hole(m3_nut_diam,m3_nut_thickness,6);
      translate([0,captive_nut_hole_len/2,0]) {
        translate([0,0,-m3_nut_diam/2]) cube([m3_nut_diam,captive_nut_hole_len,m3_nut_diam],center=true);
        translate([0,0,0]) rotate([90,0,0]) rotate([0,0,90]) hole(m3_nut_diam,captive_nut_hole_len,6);
      }
    }
  }

  difference() {
    body();
    holes();
  }

  translate([0,0,add_shaft_len/2])
    grooves(pulley_diam,num_grooves);
}

module idler_pulley(num_grooves) {
  height = get_grooved_height(num_grooves) + 1;

  difference() {
    cylinder(r=idler_diam/2,h=height,center=true,$fn=cylinder_resolution);
    for(end=[top,bottom]) {
      translate([0,0,height/2*end])
        hole(idler_bearing_diam,idler_bearing_thickness*2,24);
    }
    // for 623zz bearings
    //hole(idler_bearing_diam-.55,height+1,8);
    //hole(idler_bearing_diam-1,height+1,6);

    // for 625zz bearings
    //hole(idler_bearing_diam-1.65,height+1,6); // vs 12-sided
    //hole(idler_bearing_diam-1.9,height+1,6); // vs 18-sided
    hole(idler_bearing_diam-2,height+1,6); // vs 24-sided
  }

  grooves(idler_diam,num_grooves);
}

spacer = motor_side/2 + m5_nut_diam/2 + min_material_thickness;
//translate([-pulley_diam/2-1,0,0]) rotate([0,0,90]) motor_pulley(num_pulley_grooves);
//translate([idler_diam/2+1,0,5.5/2]) idler_pulley(num_pulley_grooves-1);
translate([-spacer/2,0,0]) rotate([0,0,90]) motor_pulley(num_pulley_grooves);
translate([spacer/2,0,5.5/2]) idler_pulley(num_pulley_grooves-1);
