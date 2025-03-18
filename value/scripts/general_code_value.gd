class_name GeneralCodeValue
extends CodeEdit

# TODO : Confirm if the theme does weird stuff on systems that use light mode by default,
#        and setup the highlighting to respond to light/dark mode ...
#        see if highlighting is themeable.

var disableAll : bool = false

signal value_changed(newText : String, me : GeneralCodeValue)

func _ready(): pass
func _process(_delta: float): pass

func set_value(newVal : String): text = newVal
func get_value() -> String: return text
func set_settings(_newVal : Variant): pass
func get_settings(): pass
func _set_disabled(disable : bool = false):
	editable = !disable
	disableAll = disable

func export(_withSettings : bool = true) -> Dictionary: return {"value":text}
func import(data : Dictionary = {"value":""}): text = data.value

func _on_text_changed(): value_changed.emit(text,self)
