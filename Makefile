# JSON file containing the models
JSON_MODELS_FILE := biothane-stencil.json

# Command to extract model names from the JSON file using Python
MODELS := $(shell python3 -c "import json; print(' '.join(json.load(open('$(JSON_MODELS_FILE)'))['parameterSets'].keys()))")

# Directories for output files
STL_DIR := dist/stl
PNG_DIR := dist/png

# Ensure the output directories exists
$(shell mkdir -p $(STL_DIR) $(PNG_DIR))

# List of target .stl files in the dist/stl/ directory
STL_FILES := $(addprefix $(STL_DIR)/,$(addsuffix .stl,$(MODELS)))

# List of target .png files in the dist/png/ directory
PNG_FILES := $(addprefix $(PNG_DIR)/,$(addsuffix .png,$(MODELS)))

# Default target
all: deduplicate $(STL_FILES) $(PNG_FILES)

# Deduplication target
deduplicate:
	python3 deduplicate_customizer.py

# Rule for creating .stl files from models
$(STL_DIR)/%.stl: biothane-stencil.scad biothane-stencil.json
	openscad --enable manifold -o $@ -p biothane-stencil.json -P $(notdir $(basename $@)) $<

# Rule for creating .png files from models
$(PNG_DIR)/%.png: biothane-stencil.scad biothane-stencil.json
	openscad --render png --imgsize 1280,1280 --enable manifold -o $@ -p biothane-stencil.json -P $(notdir $(basename $@)) $<

# Clean target to remove generated .stl and .png files from their respective directories
clean:
	rm -f $(STL_FILES)
	rm -f $(PNG_FILES)

.PHONY: all deduplicate clean
