# [name]
[summary]
## Overview
[description of structure, including only important features]

## Members
### Nodes
[full node tree structure as nested list]
* [name]
	* [subname]
		* [subsubname]

[descriptions of important nodes]

### Constants
[list of constants with brief descriptions]

### Variables
* `disableAll` (`bool`) - flag for whether the control is currently active. Set 
and unset with `_set_disabled`
[list of remaining variables with brief descriptions]

## Methods
* `_ready` - called when the node is created. Currently does nothing.
* `_process` - called on all action frames. Currently does nothing.
* `set_values` - adjusts the value, emits signals as necessary
* `get_values` - returns the current value
* `set_settings` - adjusts all settings, emits signals as necessary
* `get_settings` - returns a dictionary of all relevant settings
* `set_disable_all` - enables/disables the control completely. Sets the
disableAll flag. Does nothing for fixed assets.
* `export` - returns a dictionary with the value and possibly the settings
* `import` - acts as an initialisation function, but intended to be called more 
than once
[list of remaining methods with brief descriptions]

## Signals
* `settings_changed` - signal emits when [description of what throws the signal].
* `values_changed` - signal emits when [description of what throws the signal].
[list of specialised signals with brief descriptions]

## Listeners
[list of listeners from sub-assets and their descriptions]
