include <MCAD/units/metric.scad>
use <MCAD/array/along_curve.scad>
use <MCAD/shapes/cylinder.scad>
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <MCAD/general/sweep.scad>


number_of_blades = 12;
wall_thickness = 0.4;
hub_d = 20;
hub_od = hub_d + wall_thickness * 2;
propeller_d = 40;
blade_height = 8;
blade_thickness = 0.8;
blade_angle = 20;
blade_direction = -1;           // -1 for clockwise, 1 for counter-clockwise

$fs = 0.4;
$fa = 1;


hub ();

mcad_rotate_multiply (number_of_blades, axis = Z)
translate ([0- epsilon, 0, 0])
blade ();

module hub ()
{
    difference () {
        cylinder (d = hub_od, h = blade_height);

        translate ([0, 0, wall_thickness])
        mcad_rounded_cylinder (d = hub_od - wall_thickness * 2,
            h = blade_height * 2,
            round_r1 = 1,
            slices = 100
         );

         translate ([0, 0, -epsilon])
         cylinder (d = hub_od - wall_thickness * 4,
             h = blade_height * 2);
    }
}

module blade ()
{
    function sq (x) = x * x;
    function height2twist (h) = (
        (sq (h / blade_height)) * blade_angle * blade_direction
    );

    blade_length = propeller_d / 2;
    base_shape = rectangle_profile ([blade_length, blade_thickness]);

    transforms = [
        for (h = [0 : 0.2 : blade_height])
        rotation ([0, 0, height2twist (h)]) *
        translation ([blade_length / 2, 0, h])
    ];

    difference () {
        sweep (base_shape, transforms);

        translate ([0, 0, -epsilon])
        cylinder (d = hub_d, h = blade_height + epsilon * 2);
    }
}
