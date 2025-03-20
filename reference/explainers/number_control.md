# Number Control
A control for controlling the limits of numeric values, including provision of 
min, max, and granularity. Currently only allows for precision at `1` or `0.01`.

Must be attached to a NumberValue, either a NumberSlideValue or a
NumberSpinValue will suffice. Can be used standalone as long as an awareness of
its limitations is managed.
## Overview
The NumberControl comes in three pieces:
* `MinValue`
	* SpinBox that allows setting a minimum value
	* Limits are `-999,999,999` and `MaxValue-1`
	* Signals updates of the minimum value
* `MaxValue`
	* SpinBox that allows setting a maximum value
	* Limits are `MinValue+1` and `999,999,999`
	* Signals updates of the maximum value
* `DecimalButton`
	* Toggleable button that enables or disables decimal precision.
	* If toggled on, precision is set to `0.01`. If toggled off, precision is 
	set to `1`.
	* Signals updates of the step value.

## Members
### Nodes
* NumberControl
	* MinLabel
	* MinValue
	* Separator1
	* MaxLabel
	* MaxValue
	* Separator2
	* DecimalButton

NumberControl is simply a container for the content and serves to keep
everything organised. By using an HBox, both sections fill the same vertical
space, and growth is horizontal from the left.

MinLabel, MaxLabel, Separator1, and Separator2 are all non-interactive elements.

MinValue, MaxValue, and DecimalButton are as described above.
### Constants
N/A
### Variables
N/A
## Methods
N/A
## Signals
N/A
## Listeners
* `_on_decimal_toggled` - listens for a change to the toggle state of
`DecimalButton`. Emits `settings_changed`
* `_on_min_value_changed` - listens for a change to the value of `MinValue`. 
Emits `settings_changed`
* `_on_max_value_changed` - listens for a change to the value of `MaxValue`. 
Emits `settings_changed`
