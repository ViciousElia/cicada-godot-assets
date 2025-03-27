class_name SelectionValue
extends VBoxContainer

var disableAll : bool = false
var fixedControl : bool = false
var CSLregexp = RegEx.create_from_string("(([^,\\n\\r\\t]+\\w)\\s*[,\\n\\r\\t]?\\s*)+?")

signal values_changed(value : Variant,me : SelectionValue)
signal settings_changed(data : Dictionary,me : SelectionValue)

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : $SelectionGroup/DropdownSelector.select(newValue)
func get_values() -> Variant : return $SelectionGroup/DropdownSelector.selected
func set_settings(newSettings : Dictionary) :
	$SelectionGroup/EditButton.set_pressed(false)
	if newSettings.has("fixedControl") : fixedControl = newSettings.fixedControl
	$SelectionGroup/EditButton.visible = !fixedControl
	if newSettings.has("disable") : set_disable_all(newSettings.disable)
	if newSettings.has("list") : build_options(newSettings.list)
	elif newSettings.has("text") : _on_options_changed(newSettings.text)
func get_settings() -> Dictionary :
	var retVal = {"list":[]}
	if fixedControl : retVal["fixedControl"] = fixedControl
	if disableAll : retVal["disable"] = disableAll
	for iter in $SelectionGroup/DropdownSelector.item_count :
		retVal.list.push_back($SelectionGroup/DropdownSelector.get_item_text(iter))
	return retVal

func set_disable_all(disable : bool) :
	if fixedControl : 
		$SelectionGroup/DropdownSelector.disabled = disable
		return
	$SelectionGroup/DropdownSelector.disabled = disable
	$SelectionGroup/EditButton.disabled = disable
	$OptionsText.editable = !disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_edit_toggled(toggled_on: bool) : $OptionsText.visible = toggled_on
func _on_item_selected(index: int) : values_changed.emit(index,self)

func _on_options_changed(new_text: String) -> void:
	var list = _parse_as_units(new_text)
	build_options(list)
	settings_changed.emit(list,self)

func _parse_as_units(list : String) -> Array[String]:
	var retVal : Array[String] = []
	var matches = CSLregexp.search_all(list)
	for matched in matches:
		var groups = matched.get_strings()
		var unitText = groups[2]
		unitText = RegEx.create_from_string("[^\\w ]").sub(unitText,"",true).strip_edges()
		if unitText == "" : continue
		retVal.push_back(unitText)
	return retVal

func build_options(items : Array,cleared : bool = true):
	var oldIdx = $SelectionGroup/DropdownSelector.selected
	if cleared : $SelectionGroup/DropdownSelector.clear()
	if items.size() == 0 :
		$SelectionGroup/DropdownSelector.add_item("Item")
		$SelectionGroup/DropdownSelector.select(0)
		return
	for item in items :
		if item == "" : $SelectionGroup/DropdownSelector.add_separator()
		else : $SelectionGroup/DropdownSelector.add_item(item)
	if oldIdx >= $SelectionGroup/DropdownSelector.item_count : $SelectionGroup/DropdownSelector.select(0)
	else : $SelectionGroup/DropdownSelector.select(oldIdx)
