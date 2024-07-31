import json
import sys

# Read and collect parameters from the .scad file
parameters = {}
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
            parameters[key] = value


print('Collected the following default parameters', file=sys.stderr)
for param_key, param_value in parameters.items():
    print(f'{param_key}: {param_value}', file=sys.stderr)

# Read the JSON file
with open('biothane-stencil.json', 'r') as json_file:
    json_data = json.load(json_file)

# Iterate over all entries in parameterSets
for entry_key, parameter_set in json_data["parameterSets"].items():
    # Iterate over a list of the keys since we'll be modifying the dictionary
    for key in list(parameter_set.keys()):  # list() creates a copy of the keys
        # Delete entries that match the values in the collected parameters
        if "EXTRA" in parameter_set:
            del parameter_set["EXTRA"]
        if key in parameters: 
            print(f'Comparing {key}: "{parameters[key]}" and "{parameter_set[key]}".', file=sys.stderr)
            if parameters[key] == parameter_set[key]:
                del parameter_set[key]
            elif parameters[key] == "0.0" and parameter_set[key] == "0":
                del parameter_set[key]
            else:
                print(f'Not equal {key}: "{parameters[key]}" and "{parameter_set[key]}".', file=sys.stderr)
                

# Iterate over a copy of the items() since we'll be modifying the dictionary while iterating.
for entry_key, parameter_set in json_data["parameterSets"].copy().items():
    # Check if there is a '__base__' key in the parameter set
    if '__base__' in parameter_set:
        # Split the '__base__' value by ',' to get a list of base keys
        base_keys = parameter_set['__base__'].split(',')
        # Prefix for the newly generated parameter set
        generated_prefix = "GENERATED_"
        # Name of the new parameter set
        generated_param_set_name = generated_prefix + entry_key

        # Create the new parameter set by first adding the base key-values
        generated_param_set = {}
        # Update the new parameter set with the original parameter set values
        for key in base_keys:
            generated_param_set.update(json_data["parameterSets"][key])

        generated_param_set.update(parameter_set)

        # Remove the '__base__' key from the new parameter set as it's no longer needed
        del generated_param_set['__base__']
        
        # Add new parameter set to the json_data with the new name
        json_data["parameterSets"][generated_param_set_name] = generated_param_set

# Pretty print the JSON to console with the matching parameters removed
print(json.dumps(json_data, indent=4))