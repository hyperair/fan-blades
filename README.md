Parametric fan blades
=====================

Introduction
------------

This is a customizable, 3d-printable set of fan blades that can be attached onto
broken DC brushless fan hubs.


Instructions
-------------

1. Cut off the remaining blades of your fan hub.
2. Grind down the stubs so you get the fan hub as round and balanced as
   possible.
3. Measure the diameter of your fan hub in mm, add 0.5 for a bit of clearance,
   and specify that in `hub_d`.
4. Measure the outer diameter of your fan hub in mm, subtract 0.5, and specify
   that in `propeller_d`.
5. Measure the thickness of your hub, and specify that in `blade_thickness`.
6. Check which way your fan spins, with the fan facing you (wind blows away from
   you, towards the frame). Specify that in `blade_direction` -- `-1` for
   counter-clockwise, `1` for clockwise.
7. Print with around 0.1mm layer height, or whatever works best for you. The
   overhang can be tricky, so the lower you go without overheating your part,
   the better. Solid, because there isn't any area for infill anyway.


Required libraries
-------------------

You need to install the following into one of
[OpenSCAD's library locations](http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries#Library_Locations)

 * [MCAD (dev branch)](https://github.com/openscad/MCAD/tree/dev)
 * [scad-utils](https://github.com/openscad/scad-utils)
