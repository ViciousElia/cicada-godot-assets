class_name ColourValue
extends ColorPickerButton

var disableAll : bool = false

signal value_changed(newColour : Color,me : ColourValue)

func _ready(): pass
func _process(_delta: float): pass

func set_value(newVal : Color): color = newVal
func get_value() -> Color: return color
func set_settings(_newVal : Variant): pass
func get_settings(): pass
func _set_disabled(disable : bool = false):
	disabled = disable
	disableAll = disable

func export(_withSettings : bool = true) -> Dictionary: return {"value":color}
func import(data : Dictionary = {"value":""}): color = data.value

func _on_color_changed(color: Color): value_changed.emit(color,self)
