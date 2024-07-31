# List of model names
MODELS := GENERATED_covert_cuff_base_loxx_25mm GENERATED_end_13mm GENERATED_end_19mm GENERATED_end_25mm

# List of target .stl files
STL_FILES := $(foreach model,$(MODELS),$(model).stl)

# Default target
all: deduplicate $(STL_FILES)

# Deduplication target
deduplicate:
	python3 deduplicate_customizer.py > biothane-stencil.json.deduplicated
	mv biothane-stencil.json{.deduplicated,}

# Rule for creating .stl files from models
%.stl: biothane-stencil.scad biothane-stencil.json
	openscad --enable manifold -o $@ -p biothane-stencil.json -P $(basename $@) $<

# Clean target to remove generated .stl files
clean:
	rm -f $(STL_FILES) biothane-stencil.json.deduplicated

.PHONY: all clean