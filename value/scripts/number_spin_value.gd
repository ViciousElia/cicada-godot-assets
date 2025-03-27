class_name NumberSpinValue
extends VBoxContainer

var disableAll : bool = false
var fixedControl : bool = false

signal values_changed(value : Variant,me : NumberSpinValue)
signal settings_changed(data : Dictionary,me : NumberSpinValue)

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : $NumberSpinValueRaw.set_values(newValue)
func get_values() -> Variant : return $NumberSpinValueRaw.get_values()
func set_settings(newSettings : Dictionary) :
	if newSettings.has("fixedControl") : fixedControl = newSettings.fixedControl
	$NumberSpinValueRaw.set_settings(newSettings)
	$NumberControl.set_settings(newSettings)
func get_settings() -> Dictionary : return $NumberControl.get_settings()

func set_disable_all(disable : bool) :
	$NumberSpinValueRaw.set_disable_all(disable)
	if fixedControl : return
	$NumberControl.set_disable_all(disable)
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_settings_changed(data: Dictionary, _me : NumberControl) -> void:
	$NumberSpinValueRaw.set_settings(data)
	settings_changed.emit(data,self)
	pass

func _on_values_changed(value: Variant, _me: NumberSpinValueRaw) : values_changed.emit(value,self)
