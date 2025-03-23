class_name NumberControl
extends HBoxContainer

var disableAll : bool = false
var fixedControl : bool = false

## Currently this signal is [color=red]never emitted[/color] and should only be
## used if code is added to extend its use.
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

func set_values(newValue : Variant) : 
	if newValue is not Array : pass
	elif newValue.size() > 0 :
		$MinValue.value = newValue[0]
		if newValue.size() > 1: $MaxValue.value = newValue[1]
		if newValue.size() > 2: $DecimalButton.set_pressed(newValue[2])
func get_values() -> Variant : return [$MinValue.value,$MaxValue.value,$DecimalButton.button_pressed]
func set_settings(newSettings : Dictionary) :
	if newSettings.has("minValue") : $MinValue.value = newSettings.minValue
	if newSettings.has("maxValue") : $MaxValue.value = newSettings.maxValue
	if newSettings.has("decimal") : $DecimalButton.set_pressed_no_signal(newSettings.decimal)
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

func _on_min_value_changed(value: float) :
	if value >= $MaxValue.value :
		$MinValue.value = $MaxValue.value - 1
		return
	settings_changed.emit(get_settings(),self)
func _on_max_value_changed(value: float) :
	if value <= $MinValue.value :
		$MaxValue.value = $MinValue.value + 1
		return
	settings_changed.emit(get_settings(),self)
func _on_decimal_toggled(_toggled_on: bool) : settings_changed.emit(get_settings(),self)
