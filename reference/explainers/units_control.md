# Units Control
A control for labelling numeric values with units such as metres, feet, or rels.

Must generally be attached to a NumberValue, either a NumberSlideValue or a
NumberSpinValue will suffice. Can be used standalone as long as an awareness of
its limitations is managed.
## Overview
The UnitsControl comes in two pieces:
* `UnitsOption`
	* Dropdown menu allowing for direct selection of pre-defined units
	* Signals updates of the unit selected to connected controls.
* `UnitsText`
	* Text entry that operates in one of two modes
		* If `textOnly` is set, the value is used directly as the unit
		* If `textOnly` is **not** set, the value is used directly as the unit
	* Signals updates of the unit if `textOnly` is set, otherwise signals updates of the settings.
	* When `textOnly` is **not** set, the value should be a comma separated list with elements in one of the following formats:
		* unit_name
		* [m]unit_name
		* [m:n]unit_name
	* Brackets indicate levels of SI prefixes to use with the unit
		* `[m]` creates `m` levels smaller (d, c, m, μ, ...) and `m` levels larger (da, h, k, M, ...)
		* `[m:n]` creates `m` levels smaller and `n` levels larger
		* Example 1: [2:4]g --- provides cg,dg,g,dag,hg,kg,Mg
		* Example 2: [3:5]g,lb,[2]slug --- provides mg,cg,dg,g,dag,hg,kg,Mg,Gg,lb,cslug,dslug,slug,daslug,hslug

## Members
### Nodes
* UnitsControl
	* PickerGroup
		* UnitsOption
		* EditButton
	* TypeGroup
		* UnitsText

UnitsControl is simply a container for the content and serves to keep everything 
organised. By using a VBox, both sections fill the same horizontal space, and 
growth is vertical from the centre.

PickerGroup and TypeGroup are HBox containers that force the alignment of their 
respective elements, (because the buttons are the same size, and the other 
controls are the same height). These force-fill horizontally from the left.

EditButton toggles the TypeGroup control. When pressed, TypeGroup displays and 
can be edited to update the list. When unpressed, TypeGroup does not display. 
Unlike the default EditButton, this instance is toggleable.

UnitsOption is the actual dropdown from which elements are selected. This may 
be built as part of the initialisation or by editing UnitsText.

UnitsText accepts a comma separated list of unit names in one of the formats 
outlined above. Unit names are stripped of symbols and numbers (but not spaces) 
when building the UnitsOption list.
### Constants
* LOW_ARRAY - array of the SI prefixes from unit down to 10^-30.
* HIGH_ARRAY - the SI prefixes from unit up to 10^30.
### Variables
* `disableAll` (`bool`) - flag for whether the control is currently active. Set 
and unset with `_set_disabled`
* `textOnly` (`bool`) - flag for whether the control is using the dropdown. Set 
or unset only with `initialise`
* `fixedControl` (`bool`) - flag for whether the units provided may be changed. 
Set or unset only with `initialise`
* `CSLregexp` (`regex`)
`/((\[(\d+)(:(\d+))?\])?([^,\n\r\t]+)\s*[,\n\r\t]?\s*)+?")/` - there may be 
shorter regexs for comma separated lists, but this one takes into account the 
formatting listed above.
## Methods
* `_ready` - called when the node is created. Currently does nothing.
* `_process` - called on all action frames. Currently does nothing.
* `initialise` - builds up the settings shortly after the node is created.
* `_set_disabled` - enables/disables the control completely. Sets the disableAll 
flag.
* `_set_settings` - adjusts all settings, emits signals as necessary
* `_get_settings` - returns a dictionary of all relevant settings
* `_parse_as_units` - parses text input as comma separated formatted list and
outputs an array of options to rebuild `UnitsOption`. Outputs empty strings
for separators for any unit with `[m:n]` expanders.
## Signals
* `value_changed` - signal emits when `UnitsOption` or `UnitsText` changes
* `settings_changed` - signal emits when `UnitsText` changes
## Listeners
* `_on_edit_toggled` - listens for a change to the toggle state of `EditButton`
Shows or unshows `TypeGroup`
* `_on_units_selected` - listens for a change to the option selected in
`UnitsOption`. Emits signal `value_changed`
* `_on_units_changed` - listens for a change to the text of `UnitsText`. Emits
`settings_changed` and possibly `value_changed`
