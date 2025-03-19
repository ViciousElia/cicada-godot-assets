class_name GeneralCodeValue
extends CodeEdit

var disableAll : bool = false

signal values_changed(newText : String, me : GeneralCodeValue)

func _ready(): pass
func _process(_delta: float): pass

func set_values(newVal : String): text = newVal
func get_values() -> String: return text
func set_settings(_newVal : Variant): pass
func get_settings(): pass
func set_disable_all(disable : bool = false):
	editable = !disable
	disableAll = disable

func export(_withSettings : bool = true) -> Dictionary: return {"value":text}
func import(data : Dictionary = {"value":""}): text = data.value

func _on_text_changed(): values_changed.emit(text,self)
