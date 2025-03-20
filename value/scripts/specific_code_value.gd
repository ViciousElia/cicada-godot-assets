class_name SpecificCodeValue
extends GeneralCodeValue

# TODO : Add code for highlighting ... maybe by using secondary tools ... we'll see.
#        Probably ought to make an array whose elements match the indices of CodeLangButton?
#        We can at worst build up the highlighters and switch em with a match(idx).

func _ready() :
	# TODO : Set default highlighting mode.
	pass
func _process(_delta) : pass

func set_settings(newVal) :
	# TODO : Change highlighting modes based on idx.
	$CodeLangButton.initialise(newVal.value,newVal.rule)
func get_settings() -> Dictionary : return {"value":$CodeLangButton.selected,"rule":$CodeLangButton.fixedVal}
func set_disable_all(disable : bool = false) :
	editable = !disable
	$CodeLangButton.set_disable_all(disable)
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

func _on_code_changed(idx: int, _me: CodeLangButton) :
	# TODO : Change highlighting modes based on idx.
	settings_changed.emit(idx,self)
