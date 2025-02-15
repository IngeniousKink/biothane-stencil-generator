use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

$fn = 200;

stencil_length = 130;
row_spacing = 9;

function test_hole_punch_pliers() = concat(
  [
    "stencil_length", stencil_length,
    "include_back_pane", false,
    "material_width", 13,
    "font_size", 2.8,
    "text_left", "Famex 3519 hole punch pliers test stencil",
    "text_right", "2.0      ·      2.5      ·      3.0      ·      3.5       ·      4.0      ·      4.5      ·  ",
    "wall_thickness", 2,
  ],

  tool_hole_punch_pliers_famex_3519( 1, 2.00), hole_set( 1, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  10), // 2
  tool_hole_punch_pliers_famex_3519( 2, 2.25), hole_set( 2, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  20),
  tool_hole_punch_pliers_famex_3519( 3, 2.50), hole_set( 3, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  30), // 2.5
  tool_hole_punch_pliers_famex_3519( 4, 2.75), hole_set( 4, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  40),
  tool_hole_punch_pliers_famex_3519( 5, 3.00), hole_set( 5, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  50), // 3.0
  tool_hole_punch_pliers_famex_3519( 6, 3.25), hole_set( 6, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  60),
  tool_hole_punch_pliers_famex_3519( 7, 3.50), hole_set( 7, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  70), // 3.5
  tool_hole_punch_pliers_famex_3519( 8, 3.75), hole_set( 8, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  80),
  tool_hole_punch_pliers_famex_3519( 9, 4.00), hole_set( 9, row_spacing=row_spacing, vertical_offset=-stencil_length/2 +  90), // 4.0
  tool_hole_punch_pliers_famex_3519(10, 4.25), hole_set(10, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 100),
  tool_hole_punch_pliers_famex_3519(11, 4.50), hole_set(11, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 110), // 4.5
  tool_hole_punch_pliers_famex_3519(12, 4.75), hole_set(12, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 120),

);

biothane_stencil(concat(
    test_hole_punch_pliers(),
    get_defaults(),
));
