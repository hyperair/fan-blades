include <MCAD/units/metric.scad>
use <MCAD/array/along_curve.scad>
use <MCAD/shapes/cylinder.scad>
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <MCAD/general/sweep.scad>
use <MCAD/shapes/2Dshapes.scad>


number_of_blades = 12;
wall_thickness = 0.4;
hub_d = 20;
hub_od = hub_d + wall_thickness * 2;
propeller_d = 40;

blade_height = 8;
blade_thickness = 0.4;
blade_angle = 20;
blade_direction = 1;            // -1 for counter-clockwise, 1 for clockwise

winglets = true;
winglet_thickness = blade_thickness;
winglet_length = 2;

tab_internal_angle = 10;
tab_thickness = 0.4;
number_of_tabs = 5;
tab_width = 0.2;

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

    translate ([0, 0, blade_height])
    mcad_rotate_multiply (number_of_tabs)
    tab ();
}

module tab ()
{
    linear_extrude (height = tab_thickness) {
        intersection () {
            difference () {
                circle (d = hub_od);
                circle (d = hub_od - (tab_width + wall_thickness) * 2);
            }

            pieSlice (hub_od, -tab_internal_angle / 2, tab_internal_angle / 2);
        }
    }
}

module blade ()
{
    function twist (t) = (pow (t, 2) + 0 * t) * blade_angle * blade_direction;

    blade_length = propeller_d / 2;
    base_shape = rectangle_profile ([blade_length, blade_thickness]);
    blade_transforms = [
        for (t = [0 : 0.01 : 1.0])
        rotation ([0, 0, twist (t)]) *
        translation ([blade_length / 2, 0, (1 - t) * blade_height])
    ];

    winglet_shape = rectangle_profile ([winglet_thickness, winglet_length]);
    winglet_transforms = [
        for (i = [0 : len (blade_transforms) - 1])
        let (
            transform = blade_transforms[i],
            scale_ = max (0.01,
                (len (blade_transforms) - i) / len (blade_transforms)
            )
        )
        transform *
        translation ([
                -winglet_thickness / 2 + blade_length / 2,
                scale_ * winglet_length / 2 * blade_direction,
                0
            ]) *
        scaling ([1, scale_, 1])
    ];

    render ()
    difference () {
        union () {
            sweep (base_shape, blade_transforms);

            if (winglets)
            sweep (winglet_shape, winglet_transforms);
        }

        translate ([0, 0, -epsilon])
        cylinder (d = hub_od - epsilon * 2, h = blade_height + epsilon * 2);
    }
}
