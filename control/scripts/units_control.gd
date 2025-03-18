class_name UnitsControl
extends VBoxContainer

var disableAll : bool = false
var textOnly : bool = false
var fixedControl : bool = false

signal value_changed()
signal settings_changed()

func _ready(): pass
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
		$TypeGroup/UnitsText.text = value
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
			$PickerGroup/UnitsOption.add_item(text)
		$PickerGroup/UnitsOption.select(value)
		return
	$PickerGroup/UnitsOption.add_item("Units")
	$PickerGroup/UnitsOption.select(0)






func _parse_as_units(list : String) -> Array[String]:
	var retVal : Array[String] = []
	
	return retVal
