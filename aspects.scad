use <biothane-stencil.scad>
use <defaults.scad>

function long() = [
  "stencil_length", 150
];

function biothane_13mm() = [
  "material_width", 13
];

function biothane_25mm() = [
  "material_width", 25
];

function five_holes() = [
  "holes1_columns", 5
];

function h1_chicago_screws() = [
  "holes1_diameter", 5
];

function h2_chicago_screws() = [
  "holes2_diameter", 5
];

function h2_loxx() = [
  "holes2_diameter", 12,
  "holes2_diameter_top_multiplier", 1.4
];

function no_holes() = [
  "holes1_enabled", false,
  "holes2_enabled", false
];

function minimal_wall_thickness() = [
  "wall_thickness", 0.8
];

function standard_wall_thickness() = [
  "wall_thickness", 2
];

function front_cutouts() = [
  "back_left_cutout", true,
  "back_left_cutout_offset_side", -2,
  "back_left_cutout_offset_end", 2,
  "back_right_cutout", true,
  "back_right_cutout_offset_side", -2,
  "back_right_cutout_offset_end", 2,
  "include_front_pane", true
];

function single_end() = [
  "front_left_cutout", true,
  "front_left_cutout_offset_side", -10,
  "front_left_cutout_offset_end", 3,
  "front_right_cutout", true,
  "front_right_cutout_offset_side", -10,
  "front_right_cutout_offset_end", 3,
  "holes1_columns", 1,
  "holes1_vertical_offset", -8.5,
  "holes2_enabled", false,
  "include_back_pane", true,
  "stencil_length", 30,
  "text_left", "single end"
];

function end_13mm() = concat([
], h1_chicago_screws(), standard_wall_thickness(), single_end());

function end_19mm() = concat([
  "material_width", 19
], h1_chicago_screws(), standard_wall_thickness(), single_end());

function end_25mm() = concat([
  "material_width", 25
], h1_chicago_screws(), standard_wall_thickness(), single_end());

function double_rivet_end_19mm() = concat([
  "holes1_columns", 2,
  "holes1_diameter", 5,
  "holes1_vertical_offset", 25,
  "holes2_columns", 2,
  "holes2_diameter", 5,
  "holes2_row_spacing", 0,
  "holes2_vertical_offset", -25,
  "include_back_pane", true,
  "material_width", 19,
  "stencil_length", 80,
  "text_left", "double rivet end",
  "wall_thickness", 2
], standard_wall_thickness(), h1_chicago_screws(), h2_chicago_screws());


function tool_hand_press_with_anvil(index, anvil_diameter) = [
    /*
     * Paracord spindle hand press
     * https://www.paracord.co.uk/leather-products/basic-leather-tools/spindle-hand-press-and-accessories/spindel
     * 
     * 
     * 12mm anvil => 12.0 (untested) https://www.paracord.co.uk/leather-products/basic-leather-tools/spindle-hand-press-and-accessories/spindle-hand-press-anvil-12-mm
     * 24mm anvil => 24.0 (untested) https://www.paracord.co.uk/leather-products/basic-leather-tools/spindle-hand-press-and-accessories/spindle-hand-press-anvil-24-m-m
     * 28mm anvil => 28.0 (untested) https://www.paracord.co.uk/spindle-hand-press-anvil-28-m-m-1
     *
     *  China spindle hand press 
     *
     *  M8 hole punching anvil => 25.6 (tested) https://www.aliexpress.us/item/3256805070373470.html?gatewayAdapt=glo2usa
     *
     */

    str("holes", index, "_diameter"), anvil_diameter,
    "extra_width", anvil_diameter/2,
];

function tool_pencil_marker(index, pencil_tip_diameter=2) = [
    /*
     * Use a pencil to mark the center of where the hole needs to be, then, without the stencil 
     * use e.g. hole punch pliers to make the hole in the desired diameter.
     *
     */

    str("holes", index, "_diameter"), pencil_tip_diameter,
];

function tool_hole_punch_pliers_famex_3519(index, hole_diameter) = [
    /*
     * Use a pencil to mark the center of where the hole needs to be, then, without the stencil 
     * use e.g. hole punch pliers to make the hole in the desired diameter.
     *
     */

    str("holes", index, "_diameter"), hole_diameter + 1.5,
    str("holes", index, "_diameter_top_multiplier"), 1.3,
];