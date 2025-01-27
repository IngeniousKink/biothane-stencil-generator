use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

$fn = 200;

function double_rivet_end_25mm() = concat(
  [
    "stencil_length", 90,
    "include_back_pane", true,
    "material_width", 25,
    "text_left", "double rivet end",
    "wall_thickness", 2,
  ],

  //tool_hand_press_with_anvil(1, 25.6),
  //tool_pencil_marker(1),
  tool_hole_punch_pliers_famex_3519(1, 5.0),
  
  hole_set(
    1,
    diameter=5,
    rows=2,
    column_spacing=12.5,
    row_spacing=12.5,
    vertical_offset=28
  ),

  //tool_hand_press_with_anvil(2, 25.6),
  //tool_pencil_marker(2),
  tool_hole_punch_pliers_famex_3519(2, 5.0),

  hole_set(
    2,
    diameter=5,
    rows=2,
    column_spacing=12.5,
    row_spacing=12.5,
    vertical_offset=-15
  ),

  h1_chicago_screws(),
  h2_chicago_screws()
);


biothane_stencil(concat(
    double_rivet_end_25mm(),
    get_defaults(),
));
