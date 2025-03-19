class_name [name]
extends [inherited]

var disableAll : bool = false

signal values_changed(value : Variant,me : [name])
signal settings_changed(data : Dictionary,me : [name])

func _ready() : pass
func _process(_delta) : pass

func set_values(newValue : Variant) : pass # TODO : build set code
func get_values() -> Variant : return ""   # TODO : build get code
func set_settings(newSettings : Dictionary) : pass # TODO : build set code
func get_settings() -> Dictionary : return {}      # TODO : build get code

func set_disable_all(disable : bool) :
	# TODO : check if element is fixed ... do not enable settings for fixed elements
	# TODO : uncomment one of these OR replace them with correct lines
	#editable = !disable
	#disabled = disable
	# TODO : disable each relevant child
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)
