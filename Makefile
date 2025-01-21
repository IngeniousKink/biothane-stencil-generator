# Directories for source and output files
SCAD_DIR := .
STL_DIR := dist/stl
PNG_DIR := dist/png

# Find all .scad files in the source directory
SCAD_FILES := $(wildcard $(SCAD_DIR)/stencil_*.scad)

# Generate corresponding STL and PNG filenames
STL_FILES := $(patsubst $(SCAD_DIR)/stencil_%.scad,$(STL_DIR)/%.stl,$(SCAD_FILES))
PNG_FILES := $(patsubst $(SCAD_DIR)/stencil_%.scad,$(PNG_DIR)/%.png,$(SCAD_FILES))

# Ensure output directories exist
$(shell mkdir -p $(STL_DIR) $(PNG_DIR))

# Default target
all: $(STL_FILES) $(PNG_FILES)

# Rule for creating .stl files from .scad files
$(STL_DIR)/%.stl: $(SCAD_DIR)/stencil_%.scad
	openscad --enable manifold -o $@ $<

# Rule for creating .png files from .scad files
$(PNG_DIR)/%.png: $(SCAD_DIR)/stencil_%.scad
	openscad --render png --imgsize 1280,1280 --enable manifold -o $@ $<

# Clean target to remove generated files
clean:
	rm -f $(STL_FILES) $(PNG_FILES)

.PHONY: all clean
