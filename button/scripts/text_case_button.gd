class_name TextCaseButton
extends OptionButton

signal case_changed(idx : int,me : TextCaseButton)

func _ready():
	set_item_tooltip(0,"Allows free entry for any style of text.\nWill not strip special characters or spaces.")
	set_item_tooltip(1,"Forces the use of snake_case_text.\nStrips capital letters, spaces, and special characters except _.")
	set_item_tooltip(2,"Forces the use of camelCaseText.\nStrips spaces and special characters.\nDisallows capitals for the first character.")
	set_item_tooltip(3,"Forces the use of PascalCaseText.\nStrips spaces and special characters.\nForces capitals for the first character.")
	set_item_tooltip(4,"Forces the use of filename.case text.\nStrips spaces and special characters except _.")
	set_item_tooltip(5,"Forces the use of FILENAM8.EX3 text.\nStrips spaces and special characters.\nForces capitals.\nEnforces max length.\nEnforces <= 8 characters followed by . followed by == 3 characters.\nShort extensions will be padded with 0 on submission.")
	tooltip_text = get_item_tooltip(0)
func _process(_delta: float): pass
func initialise(value : int, fixed : bool = false):
	select(value)
	tooltip_text = get_item_tooltip(value)
	disabled = fixed

func _on_item_selected(index: int):
	tooltip_text = get_item_tooltip(index)
	case_changed.emit(index,self)
