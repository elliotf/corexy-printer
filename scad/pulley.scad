include <main.scad>;
use <util.scad>;

motor_shaft_diam = 5;
cylinder_resolution = 90;
cylinder_resolution = 12;

groove_first_to_last_dist = belt_bearing_diam - 3;
groove_diam = .8;
groove_spacing = 1.6;
turns = floor(groove_first_to_last_dist/groove_spacing);
add_shaft_len  = 8;
add_shaft_diam = 20;
total_height = groove_first_to_last_dist + groove_spacing*2 + add_shaft_len;

echo("groove first to last: ", groove_first_to_last_dist);
echo("groove spacing: ", groove_spacing);
echo("loops: ",turns+1);

module pulley_groove(pulley_diam,groove_diam) {
  rotate_extrude($fn=cylinder_resolution)
    translate([pulley_diam/2+groove_diam/2,0,0])
      scale([1*groove_diam,1.2,1])
        rotate(90)
          circle(accurate_diam(1,6),$fn=6);
}

module xy_motor_pulley(pulley_diam,first_to_last_groove_dist,num_turns,groove_diam) {
  groove_spacing = first_to_last_groove_dist / num_turns;
  pulley_height = first_to_last_groove_dist + groove_spacing*2;
  echo("Pulley groove spacing: ", groove_spacing);

  module pulley_body() {
    body_diam = pulley_diam+groove_diam;
    translate([0,0,-add_shaft_len/2])
      cylinder(r=body_diam/2,h=pulley_height+add_shaft_len,center=true,$fn=cylinder_resolution);
  }

  module pulley_holes() {
    // grooves
    translate([0,0,-first_to_last_groove_dist/2]) {
      for(end=[-1,1]) {
        for(i=[0:num_turns]) {
          translate([0,0,groove_spacing*i]) pulley_groove(pulley_diam,groove_diam);
        }
      }
    }

    // motor shaft
    difference() {
      hole(motor_shaft_diam+0.3,total_height*2,18);
      translate([2.65,0,0]) cube([1,motor_shaft_diam,total_height*2],center=true);
    }
  }

  difference() {
    pulley_body();
    pulley_holes();
  }
}

module xy_motor_pulley_idler(pulley_diam,groove_dist,num_turns,groove_diam) {
  difference() {
    union() {
      xy_motor_pulley(pulley_diam,groove_dist,num_turns,groove_diam);
      //translate([0,0,add_shaft_len/2]) cylinder(r=add_shaft_diam/2,h=add_shaft_len,center=true);
    }

    translate([0,0,-add_shaft_len/2]) {
      for(side=[-1,1]) {
        translate([0,0,total_height/2*side]) hole(pulley_idler_bearing_diam+0.1,pulley_idler_bearing_thickness,12);
      }
      //translate([0,0,groove_dist/2*side]) hole(6,10.3,18);
      //cylinder(r=10.5/2,h=groove_dist*2,center=true,$fn=6);
      cylinder(r=10.5/2,h=total_height*2,center=true,$fn=6);
    }
  }
}

% translate([pulley_diam/2+1.5,0,0]) cube([1,1,groove_first_to_last_dist],center=true);
% translate([pulley_diam/2+2.5,0,0]) cube([1,1,belt_bearing_diam],center=true);
//# color("blue", 1) translate([0,0,-xy_pulley_above_motor_plate]) motor();

translate([0,0,0]) {
  xy_motor_pulley(pulley_diam,groove_first_to_last_dist,turns,groove_diam);

  translate([-31/2,-31/2,groove_spacing/2]) xy_motor_pulley_idler(10+4,groove_first_to_last_dist,turns,groove_diam);
}

