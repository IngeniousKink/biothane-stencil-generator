use <biothane-stencil.scad>

// Function to safely get property values
function get_property(properties, key) =
    let(index = search([key], properties))
    len(index) > 0 ? properties[index[0] + 1] : undef;

// Wrapper module that uses the merged properties
module biothane_stencil_from_properties(properties) {
    biothane_stencil(
        stencil_length = get_property(properties, "stencil_length"),
        material_width = get_property(properties, "material_width"),
        side_pane_length = get_property(properties, "side_pane_length"),
        material_height = get_property(properties, "material_height"),
        wall_thickness = get_property(properties, "wall_thickness"),
        auto_side_pane_length = get_property(properties, "auto_side_pane_length"),

        holes1_enabled = get_property(properties, "holes1_enabled"),
        holes1_diameter = get_property(properties, "holes1_diameter"),
        holes1_columns = get_property(properties, "holes1_columns"),
        holes1_rows = get_property(properties, "holes1_rows"),
        holes1_column_spacing = get_property(properties, "holes1_column_spacing"),
        holes1_row_spacing = get_property(properties, "holes1_row_spacing"),
        holes1_horizontal_offset = get_property(properties, "holes1_horizontal_offset"),
        holes1_vertical_offset = get_property(properties, "holes1_vertical_offset"),
        holes1_diameter_top_multiplier = get_property(properties, "holes1_diameter_top_multiplier"),
        holes1_rivet_inner_diameter = get_property(properties, "holes1_rivet_inner_diameter"),
        holes1_anvil_guide = get_property(properties, "holes1_anvil_guide"),

        holes2_enabled = get_property(properties, "holes2_enabled"),
        holes2_diameter = get_property(properties, "holes2_diameter"),
        holes2_columns = get_property(properties, "holes2_columns"),
        holes2_rows = get_property(properties, "holes2_rows"),
        holes2_column_spacing = get_property(properties, "holes2_column_spacing"),
        holes2_row_spacing = get_property(properties, "holes2_row_spacing"),
        holes2_horizontal_offset = get_property(properties, "holes2_horizontal_offset"),
        holes2_vertical_offset = get_property(properties, "holes2_vertical_offset"),
        holes2_diameter_top_multiplier = get_property(properties, "holes2_diameter_top_multiplier"),
        holes2_rivet_inner_diameter = get_property(properties, "holes2_rivet_inner_diameter"),
        holes2_anvil_guide = get_property(properties, "holes2_anvil_guide"),

        text_left = get_property(properties, "text_left"),
        text_right = get_property(properties, "text_right"),
        font_size = get_property(properties, "font_size"),
        auto_text_right_append_material_width = get_property(properties, "auto_text_right_append_material_width"),

        include_front_pane = get_property(properties, "include_front_pane"),
        include_back_pane = get_property(properties, "include_back_pane"),

        marker_width = get_property(properties, "marker_width"),
        marker_short_mark_length = get_property(properties, "marker_short_mark_length"),
        extra_width = get_property(properties, "extra_width")
    );
}