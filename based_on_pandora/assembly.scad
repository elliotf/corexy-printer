include <./main.scad>;
use <./ab_pods.scad>;

pct_x = 130/140;

echo("build_volume[x]: ", build_volume[x]);
echo("pct_x*build_volume[x]: ", pct_x*build_volume[x]);

assembly(pct_x,0,1);
