
use <biothane-stencil.scad>
use <custom.scad>
use <properties.scad>
use <aspects.scad>
use <covert_cuff_base_loxx_25mm.scad>

union() {

  biothane_stencil_from_properties(concat(
    end_13mm(),
    get_defaults(),
  ));

  translate([20, 0, 0])
  biothane_stencil_from_properties(concat(
    covert_cuff_base_loxx_25mm(),
    get_defaults(),
  ));

}