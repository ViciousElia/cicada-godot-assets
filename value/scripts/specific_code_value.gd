class_name SpecificCodeValue
extends GeneralCodeValue

# TODO : Add code for highlighting ... maybe by using secondary tools ... we'll see.
#        Probably ought to make an array whose elements match the indices of CodeLangButton?
#        We can at worst build up the highlighters and switch em with a match(idx).

signal settings_changed(newSettings : int, me : SpecificCodeValue)

func _ready():
	# TODO : Set default highlighting mode.
	pass
func _process(_delta: float): pass

func set_settings(newVal):
	# TODO : Change highlighting modes based on idx.
	$CodeLangButton.initialise(newVal.value,newVal.rule)
func get_settings() -> Dictionary: return {"value":$CodeLangButton.selected,"rule":$CodeLangButton.fixedVal}
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

func _on_code_changed(idx: int, _me: CodeLangButton):
	# TODO : Change highlighting modes based on idx.
	settings_changed.emit(idx,self)
