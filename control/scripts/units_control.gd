class_name UnitsControl
extends VBoxContainer

var disableAll : bool = false
var textOnly : bool = false
var fixedControl : bool = false
var CSLregexp = RegEx.create_from_string("((\\[(\\d+)(:(\\d+))?\\])?([^,\\n\\r\\t]+)\\s*[,\\n\\r\\t]?\\s*)+?")

const LOW_ARRAY = ["d","c","m","μ","n","p","f","a","z","y","r","q"]
const HIGH_ARRAY = ["","da","h","k","M","G","T","P","E","Z","Y","R","Q"]

signal value_changed()
signal settings_changed()

func _ready():
	initialise(3,"[3:5]g,lb,[2]slug,[:3]pck,[4:]de,[ddd") #pass #
	
func _process(_delta: float): pass
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

func _on_option_changed(idx : int):
	value_changed.emit(idx,self)




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
