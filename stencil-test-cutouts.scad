use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

$fn = 200;

function test_cutouts() = concat(
  [
    "stencil_length", 40,
    "material_width", 13,
    "wall_thickness", 2,

    "text_left", "cutout test",

    "include_back_pane", true,
    "include_front_pane", true,

    "front_left_cutout_offset_side", 17/2,
    "front_left_cutout_offset_end", 17/2,

    "back_left_cutout_roundness", 17/2,
    "back_right_cutout_roundness", 17/2,
    
    "holes1_enabled", false,
    "holes2_enabled", false,
    ],

);


biothane_stencil(concat(
    test_cutouts(),
    get_defaults(),
));
    