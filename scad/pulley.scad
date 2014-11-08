include <config.scad>;
use <util.scad>;

cylinder_resolution = 18;
cylinder_resolution = 90;
cylinder_resolution = 225;
cylinder_resolution = 360;

add_shaft_len      = m3_nut_diam;
groove_height      = 0.7;
groove_spacing     = 1;
num_pulley_grooves = 9;

echo("PULLEY DIAM: ", pulley_diam);

function get_ridge_height(num_grooves) = groove_spacing*(num_grooves+1)+groove_height*num_grooves;

module grooves(diam,num_grooves) {
  //height = groove_spacing*(num_grooves+1)+groove_height*num_grooves;
  height = get_ridge_height(num_grooves);

  % cube([diam*2,groove_height,groove_height],center=true);
  first_to_last_groove_dist = (num_grooves-1)*(groove_spacing+groove_height);
  echo("FIRST TO LAST GROOVE DIST: ", first_to_last_groove_dist);
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
  grooved_height = get_ridge_height(num_grooves);
  add_shaft_len = m3_nut_diam;
  height = grooved_height + add_shaft_len;

  echo("MOTOR PULLEY HEIGHT: ", height);
  echo("MOTOR PULLEY GROOVE HEIGHT: ", grooved_height);

  collar_height = add_shaft_len + groove_spacing/2;
  collar_diam = pulley_diam+min_material_thickness*2;
  echo("COLLAR HEIGHT: ", collar_height);

  translate([0,0,motor_shaft_len/2]) {
    % cylinder(r=2,h=motor_shaft_len,center=true,$fn=8);
  }

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

  translate([0,0,height/2]) {
    difference() {
      body();
      holes();
    }

    translate([0,0,add_shaft_len/2])
      grooves(pulley_diam,num_grooves);
  }
}

module idler_pulley(num_grooves) {
  height = get_ridge_height(num_grooves) + 1;

  translate([0,0,height/2]) {
    difference() {
      cylinder(r=pulley_idler_diam/2,h=height,center=true,$fn=cylinder_resolution);
      for(end=[top,bottom]) {
        translate([0,0,height/2*end])
          hole(pulley_idler_bearing_diam,pulley_idler_bearing_thickness*2,24);
      }

      // shaft hole
      hole(pulley_idler_bearing_diam-2,height+1,6);
    }

    grooves(pulley_idler_diam,num_grooves);
  }
}

spacer = motor_side/2 + m5_nut_diam/2 + min_material_thickness;
translate([-spacer/2,0,0]) rotate([0,0,90]) motor_pulley(num_pulley_grooves);
//translate([spacer/2,0,5.75]) idler_pulley(num_pulley_grooves-1);
translate([spacer/2,0,0]) idler_pulley(num_pulley_grooves-1);
