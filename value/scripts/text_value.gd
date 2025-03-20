class_name TextValue
extends LineEdit

var disableAll : bool = false

signal values_changed(value : Variant,me : TextValue)
signal settings_changed(data : Dictionary,me : TextValue)

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : text = newValue
func get_values() -> Variant : return text
func set_settings(newSettings : Dictionary) : pass
func get_settings() -> Dictionary : return {}

func set_disable_all(disable : bool = false):
	editable = !disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_text_changed(): values_changed.emit(text,self)
