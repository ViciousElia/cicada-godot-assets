class_name CodeLangButton
extends OptionButton

signal code_changed(idx : int,me : CodeLangButton)

var fixedVal : bool = false

func _ready() -> void:
	set_item_tooltip(0,"Markdown syntax highlighting.\nAccepts most MDX extras, XML, and Node.js features.")
	set_item_tooltip(1,"HTML syntax highlighting.\nAccepts general XML formatting.")
	set_item_tooltip(2,"LaTeX syntax highlighting.\nAccepts most TeX compatible code.")
	set_item_tooltip(3,"BBCode style syntax highlighting.\nTreats all [tags] as valid.")
	tooltip_text = get_item_tooltip(0)
func _process(_delta: float) -> void:
	pass
func initialise(value : int, fixed : bool = false):
	select(value)
	tooltip_text = get_item_tooltip(value)
	disabled = fixed
	fixedVal = fixed
func setDisabled(disable : bool = false):
	if fixedVal : pass
	else : disabled = disable

func _on_item_selected(index: int) -> void:
	tooltip_text = get_item_tooltip(index)
	code_changed.emit(index,self)
