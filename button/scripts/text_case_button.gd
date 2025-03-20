class_name TextCaseButton
extends OptionButton

var disableAll : bool = false
var fixedControl : bool = false

signal values_changed(value : Variant,me : TextCaseButton)
signal settings_changed(data : Dictionary,me : TextCaseButton)
signal case_changed(idx : int,me : TextCaseButton)

func _ready() :
	set_item_tooltip(0,"Allows free entry for any style of text.\nWill not strip special characters or spaces.")
	set_item_tooltip(1,"Forces the use of snake_case_text.\nStrips capital letters, spaces, and special characters except _.")
	set_item_tooltip(2,"Forces the use of camelCaseText.\nStrips spaces and special characters.\nDisallows capitals for the first character.")
	set_item_tooltip(3,"Forces the use of PascalCaseText.\nStrips spaces and special characters.\nForces capitals for the first character.")
	set_item_tooltip(4,"Forces the use of filename.case text.\nStrips spaces and special characters except _.")
	set_item_tooltip(5,"Forces the use of FILENAM8.EX3 text.\nStrips spaces and special characters.\nForces capitals.\nEnforces max length.\nEnforces <= 8 characters followed by . followed by == 3 characters.\nShort extensions will be padded with 0 on submission.")
	tooltip_text = get_item_tooltip(0)
func _process(_delta) : pass

func set_values(newValue : Variant) : select(newValue)
func get_values() -> Variant : return selected
func set_settings(_newSettings : Dictionary) : pass # TODO : build set code
func get_settings() -> Dictionary : return {}      # TODO : build get code

func set_disable_all(disable : bool) :
	if fixedControl : return
	disabled = disable
	disableAll = disable

func initialise(value : int, fixed : bool = false):
	select(value)
	tooltip_text = get_item_tooltip(value)
	disabled = fixed

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_item_selected(index: int):
	tooltip_text = get_item_tooltip(index)
	case_changed.emit(index,self)
