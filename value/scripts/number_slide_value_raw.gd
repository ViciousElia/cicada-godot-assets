class_name NumberSlideValueRaw
extends HSlider

var disableAll : bool = false

signal values_changed(value : Variant,me : NumberSlideValueRaw)
signal settings_changed(data : Dictionary,me : NumberSlideValueRaw)

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : value = newValue
func get_values() -> Variant : return value
func set_settings(newValue : Dictionary) :
	if newValue.has("minValue") : min_value = newValue.minValue
	if newValue.has("maxValue") : max_value = newValue.maxValue
	if newValue.has("decimal") :
		if newValue.decimal : step = 0.01
		else : step = 1
func get_settings() -> Dictionary:
	var retVal : Dictionary = {}
	if min_value != -1000 : retVal["minValue"] = min_value
	if max_value != 1000 : retVal["maxValue"] = max_value
	if step != 1 : retVal["decimal"] = true
	return retVal

func set_disable_all(disable : bool = false):
	editable = !disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_value_changed(): values_changed.emit(value,self)
