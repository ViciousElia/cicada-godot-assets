class_name ColourValue
extends ColorPickerButton

var disableAll : bool = false

signal values_changed(value : Variant,me : ColourValue)
signal settings_changed(data : Dictionary,me : ColourValue)

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : color = newValue
func get_values() -> Variant : return color
func set_settings(newSettings : Dictionary) : pass # TODO : build set code
func get_settings() -> Dictionary : return {}      # TODO : build get code

func set_disable_all(disable : bool) :
	disabled = disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_color_changed(color: Color): values_changed.emit(color,self)
