class_name UnitsControl
extends VBoxContainer

var disableAll : bool = false
var textOnly : bool = false
var fixedControl : bool = false
var CSLregexp = RegEx.create_from_string("((\\[(\\d+)(:(\\d+))?\\])?([^,\\n\\r\\t]+)\\s*[,\\n\\r\\t]?\\s*)+?")

const LOW_ARRAY = ["d","c","m","μ","n","p","f","a","z","y","r","q"]
const HIGH_ARRAY = ["","da","h","k","M","G","T","P","E","Z","Y","R","Q"]

# TODO : Rebuild to consider values and settings differently

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
		return
	$PickerGroup/UnitsOption.clear()
	var newList = list
	if list is String:
		newList = _parse_as_units(list)
	if newList is Array :
		if newList.size() == 0:
			$PickerGroup/UnitsOption.add_item("Units")
			$PickerGroup/UnitsOption.select(0)
			return
		for text in newList:
			if text == "" : $PickerGroup/UnitsOption.add_separator()
			else : $PickerGroup/UnitsOption.add_item(text)
		$PickerGroup/UnitsOption.select(value)
		return
	$PickerGroup/UnitsOption.add_item("Units")
	$PickerGroup/UnitsOption.select(0)

func set_values(newValue : Variant) : pass # TODO : build set code
func get_values() -> Variant : return ""   # TODO : build get code
func set_settings(data : Dictionary = {"value":null}):
	if textOnly : $TypeGroup/UnitsText.text = str(data.value)
	else:
		$PickerGroup/UnitsOption.clear()
		var newList = data.options
		if newList is String :
			newList = _parse_as_units(newList)
		if newList is Array :
			if newList.size() == 0:
				$PickerGroup/UnitsOption.add_item("Units")
				$PickerGroup/UnitsOption.select(0)
				return
			for text in newList:
				if text == "" : $PickerGroup/UnitsOption.add_separator()
				else : $PickerGroup/UnitsOption.add_item(text)
			$PickerGroup/UnitsOption.select(data.value)
			return
func get_settings() -> Dictionary :
	var retVal = {}
	if textOnly : retVal["value"] = $TypeGroup/UnitsText.text
	else :
		var optArray : Array = []
		for idx in $PickerGroup/UnitsOption.item_count:
			if $PickerGroup/UnitsOption.is_item_separator(idx): optArray.push_back("")
			else : optArray.push_back($PickerGroup/UnitsOption.get_item_text(idx))
		retVal["value"] = $PickerGroup/UnitsOption.selected
		retVal["options"] = optArray
	return retVal

func set_disable_all(disable : bool) :
	# TODO : check if element is fixed ... do not enable settings for fixed elements
	# TODO : uncomment one of these OR replace them with correct lines
	#editable = !disable
	#disabled = disable
	# TODO : disable each relevant child
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)


func _on_units_selected(idx : int):
	values_changed.emit(idx,self)
func _on_units_changed(text : String):
	if textOnly : values_changed.emit (text , self)
	else :
		$PickerGroup/UnitsOption.clear()
		var newList = _parse_as_units(text)
		var oldIdx = $PickerGroup/UnitsOption.selected
		if newList.size() == 0 :
			$PickerGroup/UnitsOption.add_item("Units")
			$PickerGroup/UnitsOption.select(0)
			settings_changed.emit(["Units"],self)
			values_changed.emit(0,self)
			return
		for item in newList:
			if item == "" : $PickerGroup/UnitsOption.add_separator()
			else : $PickerGroup/UnitsOption.add_item(item)
		if oldIdx >= $PickerGroup/UnitsOption.item_count:
			$PickerGroup/UnitsOption.select(0)
		else : $PickerGroup/UnitsOption.select(oldIdx)
		settings_changed.emit(newList,self)
		values_changed.emit($PickerGroup/UnitsOption.selected,self)
func _on_edit_toggled(toggled : bool):
	$TypeGroup.visible = toggled

func _parse_as_units(list : String) -> Array[String]:
	var retVal : Array[String] = []
	var matches = CSLregexp.search_all(list)
	var separators : bool = false
	for matched in matches:
		var groups = matched.get_strings()
		if groups[3] != "":
			if int(groups[3])>0: separators = true
			elif groups[5] != "":
				if int(groups[5])>0: separators = true
	for matched in matches:
		var groups = matched.get_strings()
		var low = 0
		var high = 0
		var unitText = groups[6]
		unitText = RegEx.create_from_string("[^\\w ]|\\d").sub(unitText,"",true).strip_edges()
		if groups[3] != "":
			low = int(groups[3])
			if groups[5] != "":
				high = int(groups[5])
			else : high = low
		var locStrings = []
		for idx in low:
			locStrings.push_back(LOW_ARRAY[idx]+unitText)
		locStrings.reverse()
		for idx in high+1:
			locStrings.push_back(HIGH_ARRAY[idx]+unitText)
		retVal.append_array(locStrings)
		if separators : retVal.push_back("")
	if retVal.back() == "": retVal.pop_back()
	print(retVal)
	return retVal
