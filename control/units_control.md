# Units Control
A control for labelling numeric values with units such as metres, feet, or rels.
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
## Methods
## Signals
## Listeners
