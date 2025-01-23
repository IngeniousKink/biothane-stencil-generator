use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

function test_hole_punch_pliers() = concat(
  [
    "stencil_length", 70,
    "include_back_pane", true,
    "material_width", 25,
    "text_left", "Famex 3519 hole punch pliers",
    "wall_thickness", 2,
  ],

  hole_set(1, diameter=2.0, row_spacing=10, rows=2, vertical_offset=-35 + 10),
  hole_set(2, diameter=2.5, row_spacing=10, rows=2, vertical_offset=-35 + 20),
  hole_set(3, diameter=3.0, row_spacing=10, rows=2, vertical_offset=-35 + 30),
  hole_set(4, diameter=3.5, row_spacing=10, rows=2, vertical_offset=-35 + 40),
  hole_set(5, diameter=4.0, row_spacing=10, rows=2, vertical_offset=-35 + 50),
  hole_set(6, diameter=4.5, row_spacing=10, rows=2, vertical_offset=-35 + 60),
);

biothane_stencil(concat(
    test_hole_punch_pliers(),
    get_defaults(),
));
