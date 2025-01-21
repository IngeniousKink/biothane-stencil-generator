use <biothane-stencil.scad>
use <custom.scad>
use <properties.scad>

// Example custom properties (overrides some defaults)
long = [
  "stencil_length", 150
];

biothane_13mm= [
  "material_width", 13,
];

biothane_25mm = [
  "material_width", 25,
];

five_holes = [
  "holes1_columns", 5
];

biothane_stencil_from_properties(concat(
    long,
    biothane_25mm, 
    five_holes,
    get_defaults(),
));
