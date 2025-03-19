# Default Members and Methods
This page contains the members, methods, signals, and listeners common to every asset, 
family of assets, and structure within Cicada. Where possible, archetypal methods 
and listeners are provided and outlined.

## Members
### Nodes
No default nodes yet [there will be some for certain asset families later].

### Constants
No default constants yet [there may be some for certain asset families later].

### Variables
* `disableAll` - flag to indicate whether the asset is active and editable. Only 
intended to be set/unset with `set_disable_all`.

### Enumerations
No default enumerations yet [there may be some for certain asset families later].

## Methods
* `_ready` - called when the node is created. For many assets, this does nothing.
* `_process` - called on all action frames. For many assets, this does nothing.
* `set_values` - adjusts the value, emits signals as necessary. Accepts Variant 
datatypes. Can accept specific types for specific assets.
* `get_values` - returns the current value. Generally is Variant, but usually will 
be a specific type based on the asset.
* `set_settings` - adjusts all settings, emits signals as necessary. Accepts only 
Dictionary datatypes.
* `get_settings` - returns a Dictionary of all relevant settings. Structure of the 
Dictionary should use common names as much as possible.
* `set_disable_all` - enables/disables the control completely. Sets the 
`disableAll` flag. Does nothing for fixed assets, which have fixed settings and 
are often disabled in perpetuity. Fixed assets may be end-level or utility. Future 
state may include other designations.
* `export` - returns a dictionary with the value and possibly the settings. Content 
should be in the form `{"value" : curentValue,settings : currentSettings}`.
	* Uses references to `get_values` and `get_settings` to simplify the calls necessary
	to get values and/or settings.
	* Default definition:
```
func export(withSettings : bool = true) -> Dictionary:
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
```
* `import` - acts as an initialisation function. Typically only used during the 
setup phase, but not necessarily restricted to it. Accepts a Dictionary as its 
parameter, which should be formatted as `{"value" : curentValue,settings : currentSettings}`.
	* Uses references to `get_values` and `get_settings` to simplify the calls necessary
	to get values and/or settings.
	* Default definition:
```
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)
```
## Signals
All signals should take a value and a `me` parameter, which will allow passage of 
deeper information to the listeners as necessary.
* `values_changed` - to be emitted when any associated values of an asset are changed.
* `settings_changed` - to be emitted when any associated settings of an asset are 
changed.

## Listeners
No default listeners yet [there may be some for certain asset families later].
