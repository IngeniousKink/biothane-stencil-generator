# JSON file containing the models
JSON_MODELS_FILE := biothane-stencil.json

# Command to extract model names from the JSON file using Python
MODELS := $(shell python3 -c "import json; print(' '.join(json.load(open('$(JSON_MODELS_FILE)'))['parameterSets'].keys()))")

# List of target .stl files
STL_FILES := $(addsuffix .stl,$(MODELS))

# List of target .stl files
PNG_FILES := $(addsuffix .png,l$(MODELS))

# Default target
all: deduplicate $(STL_FILES) ${PNG_FILES}

# Deduplication target
deduplicate:
	python3 deduplicate_customizer.py

# Rule for creating .stl files from models
%.stl: biothane-stencil.scad biothane-stencil.json
	openscad --enable manifold -o $@ -p biothane-stencil.json -P $(basename $@) $<

# Rule for creating .stl files from models
%.png: biothane-stencil.scad biothane-stencil.json
	openscad --enable manifold -o $@ -p biothane-stencil.json -P $(basename $@) $<

# Clean target to remove generated .stl files
clean:
	rm -f $(STL_FILES) ${PNG_FILES}

.PHONY: all clean