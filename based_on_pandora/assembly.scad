include <./main.scad>;

//pct_x = (10+120+0)/140;
pct_x = 0;

echo("build_volume[x]: ", build_volume[x]);
echo("pct_x*build_volume[x]: ", pct_x*build_volume[x]);

assembly(1,0.5,0);
