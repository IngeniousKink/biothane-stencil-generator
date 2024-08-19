import json
import sys

with open('biothane-stencil-aspects.json', 'r') as aspects_json_file:
    aspects_data = json.load(aspects_json_file)

with open('biothane-stencil.json', 'r') as models_json_file:
    models_data = json.load(models_json_file)

# Read and collect parameters from the .scad file
scad_file_parameters = {}
with open('biothane-stencil.scad', 'r') as file:
    collect_parameters = False
    for line in file:
        line = line.strip()

        if line == "// PARAMETERS":
            collect_parameters = True
            continue

        if line == "// END OF PARAMETERS":
            break

        if collect_parameters and "=" in line:
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.split(";", 1)[0].strip().strip('"')
            scad_file_parameters[key] = value

print('Collected the following default parameters', file=sys.stderr)
for param_key, param_value in scad_file_parameters.items():
    print(f'{param_key}: {param_value}', file=sys.stderr)

for entry_key, parameter_set in aspects_data["parameterSets"].items():
    # Iterate over a list of the keys since we'll be modifying the dictionary
    for key in list(parameter_set.keys()):  # list() creates a copy of the keys
        # Delete entries that match the values in the collected parameters
        if "EXTRA" in parameter_set:
            del parameter_set["EXTRA"]
        if key in scad_file_parameters: 
            print(f'Comparing {key}: "{scad_file_parameters[key]}" and "{parameter_set[key]}".', file=sys.stderr)
            if scad_file_parameters[key] == parameter_set[key]:
                del parameter_set[key]
            elif scad_file_parameters[key] == "0.0" and parameter_set[key] == "0":
                del parameter_set[key]
            else:
                print(f'Not equal {key}: "{scad_file_parameters[key]}" and "{parameter_set[key]}".', file=sys.stderr)

output_data = {
    "fileFormatVersion": "1",
    "parameterSets": {}
}
                
# Iterate over a copy of the items() since we'll be modifying the dictionary while iterating.
for entry_key, parameter_set in aspects_data["parameterSets"].copy().items():
    # Check if there is a '__base__' key in the parameter set
    if '__base__' not in parameter_set:
        continue

    # Split the '__base__' value by ',' to get a list of base keys
    base_keys = parameter_set['__base__'].split(',')
    # Name of the new parameter set
    generated_param_set_name = entry_key

    # Create the new parameter set by first adding the base key-values
    generated_param_set = {}
    # Update the new parameter set with the original parameter set values
    for key in base_keys:
        generated_param_set.update(aspects_data["parameterSets"][key])

    generated_param_set.update(parameter_set)
    
    # Add new parameter set to the aspects_data with the new name
    output_data["parameterSets"][generated_param_set_name] = generated_param_set.copy()
    del output_data["parameterSets"][generated_param_set_name]['__base__']

with open('biothane-stencil-aspects.json', 'w') as aspects_file:
    json.dump(aspects_data, aspects_file, indent=4)

with open('biothane-stencil.json', 'w') as output_file:
    json.dump(output_data, output_file, indent=4)
