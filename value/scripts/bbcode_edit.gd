class_name BBCodeEdit
extends CodeEdit

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	var handled = false
	if event is InputEventKey:
		if event.get_modifiers_mask()&KEY_MASK_CTRL and event.pressed:
			if event.echo : return
			var selection = get_selected_text()
			var startSelectColumn = get_selection_origin_column()
			var startSelectLine = get_selection_origin_line()
			if selection == "" :
				startSelectColumn = get_caret_column()
				startSelectLine = get_caret_line()
			startSelectLine = min(startSelectLine,get_caret_line())
			startSelectColumn = min(startSelectColumn,get_caret_column())
			var tag : String = ""
			match event.keycode:
				KEY_B: # Bold
					handled = true
					tag = "[b]%s[/b]"
				KEY_I: # Italic
					handled = true
					tag = "[i]%s[/i]"
				KEY_U: # Underline
					handled = true
					tag = "[u]%s[/u]"
				KEY_MINUS: # Strikethrough
					handled = true
					tag = "[s]%s[/s]"

				KEY_M: # Align Centre (middle)
					handled = true
					tag = "[center]%s[/center]"
				KEY_L: # Align Left
					handled = true
					tag = "[left]%s[/left]"
				KEY_R: # Align Right
					handled = true
					tag = "[right]%s[/right]"

				_: return
			delete_selection()
			insert_text(tag % selection,startSelectLine,startSelectColumn)
	if handled : accept_event()
