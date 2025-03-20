class_name CodeLangButton
extends OptionButton

var disableAll : bool = false
var fixedControl : bool = false

signal values_changed(value : Variant,me : CodeLangButton)
signal settings_changed(data : Dictionary,me : CodeLangButton)
signal code_changed(idx : int,me : CodeLangButton)

func _ready() :
	set_item_tooltip(0,"Markdown syntax highlighting.\nAccepts most MDX extras, XML, and Node.js features.")
	set_item_tooltip(1,"HTML syntax highlighting.\nAccepts general XML formatting.")
	set_item_tooltip(2,"LaTeX syntax highlighting.\nAccepts most TeX compatible code.")
	set_item_tooltip(3,"BBCode style syntax highlighting.\nTreats all [tags] as valid.")
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
	fixedControl = fixed

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_item_selected(index: int):
	tooltip_text = get_item_tooltip(index)
	code_changed.emit(index,self)
