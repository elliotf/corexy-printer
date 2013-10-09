include <main.scad>;
include <lib/MCAD/regular_shapes.scad>;

motor_shaft_diam = 5;
cylinder_resolution = 90;

groove_first_to_last_dist = belt_bearing_diam;
groove_first_to_last_dist = belt_bearing_diam-3;
groove_diam = .6;
groove_spacing = groove_diam*2;
groove_spacing = 1.5;
turns = floor(groove_first_to_last_dist/groove_spacing);

module hole(len,diam,sides=16) {
  da = 1 / cos(180/sides) / 2;
  cylinder(r=da*diam,h=len,center=true,$fn=sides);
}

module pulley_groove(pulley_diam,groove_diam) {
  rotate_extrude($fn=cylinder_resolution)
    translate([pulley_diam/2+groove_diam/2,0,0])
      rotate(90) hexagon(groove_diam/2);
}

module xy_motor_pulley(pulley_diam,first_to_last_groove_dist,num_turns,groove_diam) {
  groove_spacing = first_to_last_groove_dist / num_turns;
  pulley_height = first_to_last_groove_dist + groove_diam*3;
  echo("Pulley groove spacing: ", groove_spacing);

  module pulley_body() {
    body_diam = pulley_diam+groove_diam;
    cylinder(r=body_diam/2,h=pulley_height,center=true,$fn=cylinder_resolution);
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
      hole(pulley_height+1,motor_shaft_diam+0.3,18);
      translate([2.65,0,0]) cube([1,motor_shaft_diam,pulley_height+2],center=true);
    }
  }

  difference() {
    pulley_body();
    pulley_holes();
  }
}

module xy_motor_pulley_idler(pulley_diam,groove_dist,num_turns,groove_diam) {
  difference() {
    xy_motor_pulley(pulley_diam,groove_dist,num_turns,groove_diam);
    for(side=[-1,1]) {
      translate([0,0,groove_dist/2*side]) hole(6,10.1,12);
    }
    //translate([0,0,groove_dist/2*side]) hole(6,10.3,18);
    cylinder(r=10.5/2,h=groove_dist*2,center=true,$fn=6);
  }
}

% translate([pulley_diam/2+1.5,0,0]) cube([1,1,belt_bearing_diam],center=true);

echo("groove first to last: ", groove_first_to_last_dist);
echo("groove spacing: ", groove_spacing);
echo("TURNS: ",turns);

translate([0,0,0]) {
  xy_motor_pulley(pulley_diam,groove_first_to_last_dist,turns,groove_diam);

  translate([-31/2,-31/2,0])
    xy_motor_pulley_idler(10+4,groove_first_to_last_dist,turns,groove_diam);
}

% translate([0,0,-groove_first_to_last_dist/2-5]) motor();
