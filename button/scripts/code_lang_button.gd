class_name CodeLangButton
extends OptionButton

var disableAll : bool = false

signal values_changed(value : Variant,me : CodeLangButton)
## Currently this signal is [color=red]never emitted[/color] and should only be
## used if code is added to extend its use.
signal settings_changed(data : Dictionary,me : CodeLangButton)

func _ready() :
	set_item_tooltip(0,"Markdown. Accepts MDX and most HTML.")
	set_item_tooltip(1,"HTML. Accepts HTML and generalised XML.")
	set_item_tooltip(2,"LaTeX. Accepts most valid TeX.")
	set_item_tooltip(3,"BBCode. Treats all [tags] as valid.")
	tooltip_text = get_item_tooltip(0)
func _process(_delta) : pass

func set_values(newValue : Variant) : select(newValue)
func get_values() -> Variant : return selected
func set_settings(_newSettings : Dictionary) : pass
func get_settings() -> Dictionary : return {}

func set_disable_all(disable : bool) :
	disabled = disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_item_selected(index: int) -> void:
	tooltip_text = get_item_tooltip(index)
	values_changed.emit(get_item_text(index),self)
