class_name UnitsControl
extends VBoxContainer

var disableAll : bool = false
var textOnly : bool = false
var fixedControl : bool = false
var CSLregexp = RegEx.create_from_string("((\\[(\\d+)(:(\\d+))?\\])?([^,\\n\\r\\t]+)\\s*[,\\n\\r\\t]?\\s*)+?")

const LOW_ARRAY = ["d","c","m","μ","n","p","f","a","z","y","r","q"]
const HIGH_ARRAY = ["","da","h","k","M","G","T","P","E","Z","Y","R","Q"]

signal values_changed(value : Variant,me : UnitsControl)
signal settings_changed(data : Dictionary,me : UnitsControl)

func _ready() : pass # initialise(3,"[3:5]g,lb,[2]slug,[:3]pck,[4:]de,[ddd") #
func _process(_delta) : pass
func initialise(value : Variant, list : Variant = null, textUnit : bool = false, fixedSet : bool = false):
	if fixedSet :
		$TypeGroup/UnitsText.editable = false
		$PickerGroup/EditButton.visible = false
	textOnly = textUnit
	fixedControl = fixedSet
	if textUnit :
		$PickerGroup.visible = false
		$TypeGroup/ConfirmButton.visible = false
		$TypeGroup.visible = true
		$TypeGroup/UnitsText.text = str(value)
		$TypeGroup/UnitsText.tooltip_text = "The unit associated with the value."
		$TypeGroup/UnitsText.placeholder_text = "Unit name"
		return
	$TypeGroup/UnitsText.tooltip_text = "Comma separated list of unit names.\nIf left blank, the dropdown defaults to Units.\nBrackets in a unit name will add prefixes.\n[1:3] will add d,da,h,k\n[3:1] will add m,c,d,da\n[3] will add m,c,d,da,h,k.\nMaximum value in brackets is 12"
	$TypeGroup/UnitsText.placeholder_text = "Comma separated list of unit names."
	$PickerGroup/UnitsOption.clear()
	var newList = list
	if list is String : newList = _parse_as_units(list)
	if newList is Array : build_options(newList)
	else :
		$PickerGroup/UnitsOption.add_item("Units")
		$PickerGroup/UnitsOption.select(0)

func set_values(newValue : Variant) :
	if textOnly : $TypeGroup/UnitsText.text = newValue
	else : $PickerGroup/UnitsOption.select(newValue)
func get_values() -> Variant :
	if textOnly : return $TypeGroup/UnitsText.text
	else : return $PickerGroup/UnitsOption.selected
func set_settings(newSettings : Dictionary) :
	fixedControl = newSettings.fixedControl
	if newSettings.textOnly && !textOnly : initialise(newSettings.value,null,newSettings.textOnly,newSettings.fixedControl)
	elif newSettings.textOnly :
		$TypeGroup/UnitsText.text = newSettings.value
		if fixedControl : $TypeGroup/UnitsText.editable = false
		else : $TypeGroup/UnitsText.editable = true
	elif textOnly : initialise(0,newSettings.list,newSettings.textOnly,newSettings.fixedControl)
	else :
		$PickerGroup/EditButton.visible = !fixedControl
		if fixedControl : $PickerGroup/EditButton.set_pressed(false)
		$PickerGroup/UnitsOption.clear()
		var newList = newSettings.list
		if newList is String : newList = _parse_as_units(newList)
		if newList is Array : build_options(newList)
func get_settings() -> Dictionary :
	var retVal : Dictionary = {"textOnly" : textOnly,"fixedControl" : fixedControl}
	if textOnly : retVal["value"] = $TypeGroup/UnitsText.text
	else :
		var newList : Array[String] = []
		for idx in $PickerGroup/UnitsOption.item_count :
			if $PickerGroup/UnitsOption.is_item_separator(idx) : newList.push_back("")
			else : newList.push_back($PickerGroup/UnitsOption.get_item_text(idx))
		retVal["list"] = newList
	return retVal

func set_disable_all(disable : bool) :
	if fixedControl : return
	$PickerGroup/UnitsOption.disabled = disable
	$TypeGroup/UnitsText.editable = !disable
	$PickerGroup/EditButton.disabled = disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_units_selected(idx : int) : values_changed.emit(idx,self)
func _on_units_changed(text : String):
	if textOnly : values_changed.emit (text , self)
	else :
		var newList = _parse_as_units(text)
		build_options(newList)
		settings_changed.emit(newList,self)
		values_changed.emit($PickerGroup/UnitsOption.selected,self)
func _on_edit_toggled(toggled : bool) : $TypeGroup.visible = toggled

func _parse_as_units(list : String) -> Array[String]:
	var retVal : Array[String] = []
	var matches = CSLregexp.search_all(list)
	var separators : bool = false
	for matched in matches:
		var groups = matched.get_strings()
		if groups[3] != "" :
			if int(groups[3])>0 : separators = true
			elif groups[5] != "" : if int(groups[5])>0: separators = true
	for matched in matches:
		var groups = matched.get_strings()
		var low = 0
		var high = 0
		var unitText = groups[6]
		unitText = RegEx.create_from_string("[^\\w ]|\\d").sub(unitText,"",true).strip_edges()
		if groups[3] != "" :
			low = int(groups[3])
			if groups[5] != "" : high = int(groups[5])
			else : high = low
		var locStrings = []
		for idx in low : locStrings.push_back(LOW_ARRAY[idx]+unitText)
		locStrings.reverse()
		for idx in high+1 : locStrings.push_back(HIGH_ARRAY[idx]+unitText)
		retVal.append_array(locStrings)
		if separators : retVal.push_back("")
	if retVal.back() == "" : retVal.pop_back()
#	print(retVal)
	return retVal

func build_options(items : Array,cleared : bool = true):
	var oldIdx = $PickerGroup/UnitsOption.selected
	if cleared : $PickerGroup/UnitsOption.clear()
	if items.size() == 0 :
		$PickerGroup/UnitsOption.add_item("Units")
		$PickerGroup/UnitsOption.select(0)
		return
	for item in items :
		if item == "" : $PickerGroup/UnitsOption.add_separator()
		else : $PickerGroup/UnitsOption.add_item(item)
	if oldIdx >= $PickerGroup/UnitsOption.item_count : $PickerGroup/UnitsOption.select(0)
	else : $PickerGroup/UnitsOption.select(oldIdx)
