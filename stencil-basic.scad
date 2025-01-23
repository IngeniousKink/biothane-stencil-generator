
use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

union() {

  biothane_stencil(concat(

    ["stencil_length", 150],
    ["material_width", 25],
    ["holes1_columns", 10],
    ["holes2_enabled", false],
    
    get_defaults(),
  ));

}