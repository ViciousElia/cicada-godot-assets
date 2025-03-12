class_name CodeValue
extends CodeEdit

signal value_changed(value : String, me : CodeValue)
signal code_changed(value : int, me : CodeValue)

var disableAll : bool = false
var fixedCode : bool = false

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func initialise(value : String, case : int = 0, fixed : bool = false):
	text = value
	$CodeLangButton.initialise(case,fixed)
	fixedCode = fixed

func set_value(data : String):
	text = data
func get_value() -> String:
	return text
func set_code(data : int):
	$CodeLangButton.select(data)
func get_code() -> int:
	return $CodeLangButton.selected
func set_disabled(disable : bool):
	if fixedCode : $CodeLangButton.disabled = true
	else : $CodeLangButton.disabled = disable
	editable = !disable
	disableAll = disable

func _on_text_changed() -> void:
	value_changed.emit(text,self)
func _on_code_changed(idx: int, _me: CodeLangButton) -> void:
	# TODO: update highlighting
	code_changed.emit(idx,self)
