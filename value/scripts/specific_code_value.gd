class_name SpecificCodeValue
extends GeneralCodeValue

# TODO : Add code for highlighting ... maybe by using secondary tools ... we'll see
# TODO : Add event listeners ... needs code_changed from $CodeLangButton and text_changed behaves as parent ... 
# TODO : Add signals ... only needs settings_changed ... value_changed behaves as parent ...

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass

# func set_value(newVal : String): Set/Get value use the same definition as General
# func get_value() -> String:
func set_settings(newVal):
	$CodeLangButton.initialise(newVal.value,newVal.rule)
func get_settings():
	return {"value":$CodeLangButton.selected,"rule":$CodeLangButton.fixedVal}
func _set_disabled(disable : bool = false):
	editable = !disable
	$CodeLangButton._set_disabled(disable)
	disableAll = disable

func export(withSettings : bool = true) -> Dictionary:
	if withSettings : return {"value":text,"settings":$CodeLangButton.selected}
	else : return {"value":text}
func import(data : Dictionary = {"value":""}):
	text = data.value
	if data.has("settings") :
		$CodeLangButton.initialise(data.settings.value,data.settings.rule)
