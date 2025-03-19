# Cicada - a Consistently Interfacing Godot Asset Library (G-4.3)
## Overview
A collection of assets designed specifically to consistently interface with each 
other or with other nodes. Built with the explicit goal of using the same names 
for members, methods, signals, listeners (when possible), and input/output 
formats.

### Resources
| Resource | Description | Notes |
| --- | --- | --- |
| [Godot Reference](https://docs.godotengine.org/) | The complete reference of default Godot assets and behaviours. | Open source documentation project |
| [MIT License](https://github.com/godotengine/godot/blob/master/LICENSE.txt) | Overview of the license under which Godot is made public. | Many projects with Godot are partially or completely subject to the MIT License |
| | | |
## Rationale
Many Godot Control nodes use disparate connections, signals, members, and
methods. This results in a highly inconsistent coding experience when building 
GUIs and other interfaces.

At the most basic levels, consistent experiences are intended for data as
text, longtext, numbers, units, colours, code, and some buttons.

Without such a consistent experience, the designer will have to account for all 
possible assets. This is both inconvenient and inefficient.

## Goal
Rather than referring to `text`, `value`, `color`, `selected`, and
`button_pressed`, all states will be retrievable and editable via `get_values` 
and `set_values` so that when referring to any element, regardless of type, the 
same code may be used. Due to the existing methods for `set_value` and
`get_value` on some elements, the name is pluralised to allow the functions to
be created for all assets.

In addition, all end-level assets will have `set_settings` for configuration
and `get_settings` recovery of configurations. Not all configurations will be 
accessible, since they are manageable at design-time rather than run-time, but 
those configurations that are reasonable should be accessible and editable at 
run-time via consistent code. [This goal will need to be revisited now that
it's been explicitly stated, as it's not currently implemented as such.]

Finally, all end-level assets should have `import` and `export` methods that can 
build or recover both values and settings.

Assets built as utility elements (those in the control directory) will also have 
an `initialise` method to pre-configure them. When building with these elements, 
it will be necessary to add `import`/`export` code and others, since they are 
not built to be end-level.
## Projects
Below are projects using these assets. The list will be short for a while.
### Current
* Book Planner
### Future
### Past
