class_name SpecificCodeValue
extends GeneralCodeValue

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass

# func set_value(newVal : String): Set/Get value use the same definition as General
# func get_value() -> String:
func set_settings(newVal):
	$CodeLangButton.select(newVal)
func get_settings():
	return $CodeLangButton.selected
func set_disabled(disable : bool = false):
	editable = !disable
	$CodeLangButton.set_disabled(disable)
	disableAll = disable

func export(withSettings : bool = true) -> Dictionary:
	if withSettings : return {"value":text,"settings":$CodeLangButton.selected}
	else : return {"value":text}
func import(data : Dictionary = {"value":""}):
	text = data.value
