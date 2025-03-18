class_name FlagLabel
extends Label

signal value_changed(newText : String, me : FlagLabel)

var disableAll : bool = false

func _ready(): pass
func _process(_delta: float): pass
func initialise(value : String, freeLabel : bool = false) -> void:
	set_value(value)
	$EditButton.visible = freeLabel

func set_value(data : String):
	text = data
	$LineEdit.text = data
func get_value() -> String: return text
func set_settings(data : LabelSettings): label_settings = data
func get_settings(): return label_settings
func _set_disabled(disable : bool):
	$EditButton.disabled = disable
	$LineEdit/ConfirmButton.disabled = disable
	$LineEdit/CancelButton.disabled = disable
	$LineEdit.editable = !disable
	disableAll = disable

### MAIN OBJECT METHODS ###
func _on_gui_input(event: InputEvent) -> void:
	if disableAll : return
	if event is InputEventMouseButton:
		if event.double_click and event.button_index&MOUSE_BUTTON_MASK_LEFT:
			if $EditButton.visible : _on_edit_button_pressed()

### BUTTON METHODS ###
func _on_edit_button_pressed() -> void:
	$LineEdit.visible = true
	$LineEdit.grab_focus()
func _on_confirm_button_pressed() -> void:
	if $LineEdit.text != "":
		text = $LineEdit.text
		value_changed.emit($LineEdit.text, self)
	else : $LineEdit.text = text
	$LineEdit.visible = false
func _on_cancel_button_pressed() -> void:
	$LineEdit.text = text
	$LineEdit.visible = false

### EDIT OBJECT METHODS ###
func _on_text_submitted(_new_text: String): _on_confirm_button_pressed()
func _on_text_gui_input(event: InputEvent):
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE: _on_cancel_button_pressed()
			KEY_TAB: _on_confirm_button_pressed()
			_: pass
func _on_text_focus_exited():
	var local_position = get_viewport().get_mouse_position() - position
	if local_position.x >= 0 and local_position.x <= size.x:
		if local_position.y >=0 and local_position.y <= size.y:
			return
	_on_confirm_button_pressed()

func export(_withSettings : bool = true) -> Dictionary:
	if _withSettings : return {"value":text,"settings":{"visual":label_settings,"functional":$EditButton.visible}}
	else : return {"value":text}
func import(data : Dictionary):
	set_value(data.value)
	if data.has("settings") : 
		$EditButton.visible = data.settings.functional
		label_settings = data.settings.visual
	pass
