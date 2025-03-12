class_name UnitsValue
extends HBoxContainer

signal options_changed(newChoices : Array[String], me : UnitsValue)
signal units_changed(newVal : Variant, me : UnitsValue)
signal value_changed(newVal : float, me : UnitsValue)

var disableAll : bool = false
var fixSettings : bool = false
var stringSet : bool = false

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func initialise(val : Variant, choices : Array = ["Units"],fixSet : bool = false,isString : bool = false):
	stringSet = isString
	if stringSet :
		$UnitsControls/DropGroup.visible = false
		$UnitsControls/UnitsEdit.visible = true
		$UnitsControls/UnitsEdit/ConfirmButton.visible = false
	fixSettings = fixSet
	if fixSet and !stringSet:
		$UnitsControls/DropGroup/EditButton.visible = false
	if !stringSet :
		$UnitsControls/UnitsEdit.text = ",".join(choices)
		_on_units_text_changed($UnitsControls/UnitsEdit.text)
		$UnitsControls/DropGroup/UnitsChoice.select(val)
	else : $UnitsControls/UnitsEdit.text = val

func set_value(val : Variant):
	if stringSet : $UnitsControls/UnitsEdit.text = val
	$UnitsControls/DropGroup/UnitsChoice.select(val)
func get_value() -> Variant:
	if stringSet : return $UnitsControls/UnitsEdit.text
	return $UnitsControls/DropGroup/UnitsChoice.selected
func set_options(choices : Array[String]):
	if fixSettings : return
	if stringSet : return
	$UnitsControls/UnitsEdit.text = ",".join(choices)
	_on_units_text_changed($UnitsControls/UnitsEdit.text)
func get_options() -> Array[String]:
	if stringSet : return []
	var items : Array = []
	for idx in $UnitsControls/DropGroup/UnitsChoice.item_count:
		items.push_back($UnitsControls/DropGroup/UnitsChoice.get_item_text(idx))
	return items
func set_disabled(disable : bool):
	$UnitsControls/DropGroup/UnitsChoice.disabled = disable
	$UnitsControls/DropGroup/EditButton.disabled = disable
	$UnitsControls/UnitsEdit.editable = !disable
	$UnitsControls/UnitsEdit/ConfirmButton.disabled = disable
	$NumberValue.set_disabled(disable)
	disableAll = disable

func _on_units_text_changed(new_text: String) -> void:
	print("ping")
	if stringSet : value_changed.emit($UnitsControls/UnitsEdit.text,self)
	var idx = $UnitsControls/DropGroup/UnitsChoice.selected
	if idx < 0: idx = 0
	var items : Array = []
	$UnitsControls/DropGroup/UnitsChoice.clear()
	if new_text == "": $UnitsControls/DropGroup/UnitsChoice.add_item("Units")
	else:
		var commaSep = RegEx.create_from_string(" *([^,\\n\\r\\t]*[^\\s,]),?")
		var matchList = commaSep.search_all(new_text)
		if matchList.size() > 0:
			for item in matchList:
				$UnitsControls/DropGroup/UnitsChoice.add_item(item.strings[1])
				items.push_back(item.strings[1])
		else:
			$UnitsControls/DropGroup/UnitsChoice.add_item("Units")
	if $UnitsControls/DropGroup/UnitsChoice.item_count < 1: items.push_back("Units")
	if idx < $UnitsControls/DropGroup/UnitsChoice.item_count: $UnitsControls/DropGroup/UnitsChoice.select(idx)
	else: $UnitsControls/DropGroup/UnitsChoice.select(0)
	options_changed.emit(items,self)
	if idx != $UnitsControls/DropGroup/UnitsChoice.selected: units_changed.emit($UnitsControls/DropGroup/UnitsChoice.selected,self)

func _on_edit_button_pressed() -> void:
	$UnitsControls/DropGroup.visible = false
	$UnitsControls/UnitsEdit.visible = true
func _on_confirm_button_pressed() -> void:
	$UnitsControls/DropGroup.visible = true
	$UnitsControls/UnitsEdit.visible = false
func _on_value_changed(newVal: float, _me: NumberValue) -> void:
	value_changed.emit(newVal,self)
func _on_units_selected(index: int) -> void:
	units_changed.emit(index,self)
