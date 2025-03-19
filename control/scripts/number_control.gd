class_name NumberControl
extends HBoxContainer

var disableAll : bool = false
var fixedControl : bool = false

# TODO : Rebuild to consider values and settings differently

signal values_changed(value : Variant,me : NumberControl)
signal settings_changed(data : Dictionary,me : NumberControl)

func _ready() : pass
func _process(_delta) : pass
func initialise(settings : Dictionary = {"minValue":-1000,"maxValue":1000,"decimal":false}, fixedAll : bool = false):
	if settings.has("minValue") : $MinValue.value = settings.minValue
	if settings.has("maxValue") : $MaxValue.value = settings.maxValue
	if settings.has("decimal") : $DecimalButton.set_pressed_no_signal(settings.decimal)
	set_disable_all(fixedControl)
	fixedControl = fixedAll

func set_values(newValue : Variant) : pass # TODO : build set code
func get_values() -> Variant : return null   # TODO : build get code
func set_settings(data : Dictionary = {"minValue":-1000,"maxValue":1000,"decimal":false}) :
	if data.has("minValue") : $MinValue.value = data.minValue
	if data.has("maxValue") : $MaxValue.value = data.maxValue
	if data.has("decimal") : $DecimalButton.set_pressed_no_signal(data.decimal)
func get_settings() -> Dictionary:
	var retVal = {}
	if $MinValue.value != -1000 : retVal["minValue"] = $MinValue.value
	if $MaxValue.value != 1000 : retVal["maxValue"] = $MaxValue.value
	if $DecimalButton.button_pressed : retVal["decimal"] = true
	return retVal

func set_disable_all(disable : bool) :
	if fixedControl : return
	$MinValue.editable = !disable
	$MaxValue.editable = !disable
	$DecimalButton.disabled = disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_min_value_changed(value: float):
	if value >= $MaxValue.value :
		$MinValue.value = $MaxValue.value - 1
		return
	var retVal = {}
	if value != -1000 : retVal["minValue"] = value
	if $MaxValue.value != 1000 : retVal["maxValue"] = $MaxValue.value
	if $DecimalButton.button_pressed : retVal["decimal"] = true
	settings_changed.emit(retVal,self)
func _on_max_value_changed(value: float):
	if value <= $MinValue.value :
		$MaxValue.value = $MinValue.value + 1
		return
	var retVal = {}
	if $MinValue.value != -1000 : retVal["minValue"] = $MinValue.value
	if value != 1000 : retVal["maxValue"] = value
	if $DecimalButton.button_pressed : retVal["decimal"] = true
	settings_changed.emit(retVal,self)
func _on_decimal_toggled(toggled_on: bool):
	var retVal = {}
	if $MinValue.value != -1000 : retVal["minValue"] = $MinValue.value
	if $MaxValue.value != 1000 : retVal["maxValue"] = $MaxValue.value
	if toggled_on : retVal["decimal"] = true
	settings_changed.emit(retVal,self)
