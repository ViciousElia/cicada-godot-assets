class_name NumberControl
extends HBoxContainer

var disableAll : bool = false
var fixedControl : bool = false

signal settings_changed(data : Dictionary,me : NumberControl)

func _ready(): pass
func _process(_delta: float): pass

func _set_settings(data : Dictionary = {"minValue":-1000,"maxValue":1000,"decimal":false}) :
	if data.has("minValue") : $MinValue.value = data.minValue
	if data.has("maxValue") : $MaxValue.value = data.maxValue
	if data.has("decimal") : $DecimalButton.set_pressed_no_signal(data.decimal)
func _get_settings() -> Dictionary:
	var retVal = {}
	if $MinValue.value != -1000 : retVal["minValue"] = $MinValue.value
	if $MaxValue.value != 1000 : retVal["maxValue"] = $MaxValue.value
	if $DecimalButton.button_pressed : retVal["decimal"] = true
	return retVal
func initialise(settings : Dictionary = {"minValue":-1000,"maxValue":1000,"decimal":false}, fixedAll : bool = false):
	if settings.has("minValue") : $MinValue.value = settings.minValue
	if settings.has("maxValue") : $MaxValue.value = settings.maxValue
	if settings.has("decimal") : $DecimalButton.set_pressed_no_signal(settings.decimal)
	_set_disabled(fixedAll)
	fixedControl = fixedAll
func _set_disabled(disable : bool = false):
	if fixedControl : return
	$MinValue.editable = !disable
	$MaxValue.editable = !disable
	$DecimalButton.disabled = disable
	disableAll = disable
	pass

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
