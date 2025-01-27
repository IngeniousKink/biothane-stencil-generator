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

  hole_set(1, diameter=3.5, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 10), // 2
  hole_set(2, diameter=3.75, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 20),
  hole_set(3, diameter=4.0, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 30), // 2.5
  hole_set(4, diameter=4.25, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 40),
  hole_set(5, diameter=4.5, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 50), // 3.0
  hole_set(6, diameter=4.75, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 60),
  hole_set(7, diameter=5.0, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 70), // 3.5
  hole_set(8, diameter=5.25, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 80),
  hole_set(9, diameter=5.5, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 90), // 4.0
  hole_set(10, diameter=5.75, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 100),
  hole_set(11, diameter=6.0, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 110), // 4.5
  hole_set(12, diameter=6.25, row_spacing=row_spacing, vertical_offset=-stencil_length/2 + 120),

);

biothane_stencil(concat(
    test_hole_punch_pliers(),
    get_defaults(),
));
