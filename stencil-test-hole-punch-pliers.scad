use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

stencil_length = 110;
row_spacing = 9;

function test_hole_punch_pliers() = concat(
  [
    "stencil_length", stencil_length,
    "include_back_pane", true,
    "material_width", 25,
    "font_size", 3.2,
    "text_left", "Famex 3519 hole punch pliers",
    "text_right", "2.0 · 2.5 · 3.0 · 3.5 · 4.0 · 4.5 · 5.0 · 5.5 · 6.0 · 6.5",
    "wall_thickness", 2,
  ],

  hole_set(1, diameter=2.0, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 10),
  hole_set(2, diameter=2.5, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 20),
  hole_set(3, diameter=3.0, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 30),
  hole_set(4, diameter=3.5, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 40),
  hole_set(5, diameter=4.0, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 50),
  hole_set(6, diameter=4.5, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 60),
  hole_set(7, diameter=5.0, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 70),
  hole_set(8, diameter=5.5, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 80),
  hole_set(9, diameter=6.0, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 90),
  hole_set(10, diameter=6.5, row_spacing=row_spacing, rows=2, vertical_offset=-stencil_length/2 + 100),

);

biothane_stencil(concat(
    test_hole_punch_pliers(),
    get_defaults(),
));
