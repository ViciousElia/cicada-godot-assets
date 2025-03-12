class_name NumberValue
extends VBoxContainer

signal value_changed(newVal : float,me : NumberValue)

var disableAll : bool = true
var fixedSetting : bool = false

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func initialise(val: float,fixedSet: bool = false,minVal: int = 0,maxVal: int = 100,allowDecimal: bool = false):
	$NumberControlsGroup/MinValue.value = minVal
	$NumberControlsGroup/MaxValue.value = maxVal
	$NumberControlsGroup/DecimalButton.set_pressed(allowDecimal)
	$NumberSlider.value = val
	fixedSetting = fixedSet
	if fixedSet :
		for idx in range(1,$NumberControlsGroup.get_child_count()):
			$NumberControlsGroup.get_child(idx).visible = false

func set_value(newVal : float):
	$NumberSlider.value = newVal
func get_value() -> float:
	return $NumberSlider.value
func set_min(newVal : float):
	$NumberControlsGroup/MinValue.value = newVal
func get_min() -> float:
	return $NumberControlsGroup/MinValue.value
func set_max(newVal : float):
	$NumberControlsGroup/MaxValue.value = newVal
func get_max() -> float:
	return $NumberControlsGroup/MaxValue.value
func set_decimal(newVal : bool):
	$NumberControlsGroup/DecimalButton.set_pressed(newVal)
func get_decimal() -> bool:
	return $NumberControlsGroup/DecimalButton.button_pressed
func get_settings() -> Dictionary:
	return {"minVal":$NumberSlider.min_value,"maxVal":$NumberSlider.max_value,"decimal":$NumberControlsGroup/DecimalButton.button_pressed,"fixed":fixedSetting}
func set_disabled(disable : bool):
	for idx in $NumberControlsGroup.get_child_count():
		var node = $NumberControlsGroup.get_child(idx)
		if "disabled" in node: node.disabled = disable
		if "editable" in node: node.editable = !disable
	$NumberSlider.editable = !disable
	disableAll=disable

func _on_min_value_changed(value: float) -> void:
	if value > $NumberControlsGroup/MaxValue.value:
		$NumberControlsGroup/MinValue.value = $NumberControlsGroup/MaxValue.value-1
	$NumberSlider.min_value = $NumberControlsGroup/MinValue.value
	$NumberControlsGroup/QuickValueView.min_value = $NumberControlsGroup/MinValue.value
func _on_max_value_changed(value: float) -> void:
	if value < $NumberControlsGroup/MinValue.value:
		$NumberControlsGroup/MaxValue.value = $NumberControlsGroup/MinValue.value+1
	$NumberSlider.max_value = $NumberControlsGroup/MaxValue.value
	$NumberControlsGroup/QuickValueView.max_value = $NumberControlsGroup/MaxValue.value
func _on_decimal_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$NumberSlider.step = 0.01
		$NumberControlsGroup/QuickValueView.step = 0.01
	else:
		$NumberSlider.step = 1
		$NumberControlsGroup/QuickValueView.step = 1
func _on_number_value_changed(value: float) -> void:
	if $NumberControlsGroup/QuickValueView.value != value:
		$NumberControlsGroup/QuickValueView.value = value
	value_changed.emit(value,self)
func _on_view_value_changed(value: float) -> void:
	if $NumberSlider.value != value:
		$NumberSlider.value = value
	value_changed.emit(value,self)
