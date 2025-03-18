class_name NumberSpinValueRaw
extends SpinBox

var disableAll : bool = false

signal _value_changed(newVal : float, me : NumberSpinValueRaw)

func _ready(): pass
func _process(_delta: float): pass

# Set/Get Value are built-in and work as expected
func _set_settings(newVal : Variant):
	if newVal is Dictionary:
		if newVal.has("minValue") : min_value = newVal.minValue
		if newVal.has("maxValue") : max_value = newVal.maxValue
		if newVal.has("decimal") :
			if newVal.decimal : step = 0.01
			else : step = 1
func _get_settings() -> Dictionary:
	var retVal : Dictionary = {}
	if min_value != -1000 : retVal["minValue"] = min_value
	if max_value != 1000 : retVal["maxValue"] = max_value
	if step != 1 : retVal["decimal"] = true
	return retVal
func _set_disabled(disable : bool = false):
	editable = !disable
	disableAll = disable

func _export(withSettings : bool = true) -> Dictionary:
	var retVal : Dictionary = {"value" : value}
	if withSettings : retVal["settings"] = _get_settings()
	return retVal
func _import(data : Dictionary = {"value":0}):
	if data.has("settings") : _set_settings(data.settings)
	value = data.value

func _on_value_changed(): _value_changed.emit(value,self)
