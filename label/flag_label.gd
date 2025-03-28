class_name FlagLabel
extends Label

var disableAll : bool = false
var fixedControl : bool = false

# TODO : make everything work like my other stuff I guess?

signal values_changed(value : Variant,me : FlagLabel)
## Currently this signal is [color=red]never emitted[/color] and should only be
## used if code is added to extend its use.
signal settings_changed(data : Dictionary,me : FlagLabel)

func _ready() : pass
func _process(_delta) : pass
func initialise(value : String, freeLabel : bool = false) -> void:
	set_values(value)
	$EditButton.visible = freeLabel
	fixedControl = !freeLabel

func set_values(data : Variant) :
	text = data
	$LineEdit.text = data
func get_values() -> Variant : return text
func set_settings(newSettings : Dictionary) :
	label_settings = newSettings.style
	fixedControl = newSettings.fixedControl
	$EditButton.visible = !fixedControl
	$EditButton.set_pressed(!fixedControl)
func get_settings() -> Dictionary : return {"style" : label_settings,"fixedControl" : fixedControl}

func set_disable_all(disable : bool) :
	if fixedControl : return
	$EditButton.disabled = disable
	$LineEdit/ConfirmButton.disabled = disable
	$LineEdit/CancelButton.disabled = disable
	$LineEdit.editable = !disable
	disableAll = disable

func export(withSettings : bool = false) :
	if withSettings : return {"value" : get_values(),"settings" : get_settings()}
	else : return {"value" : get_values()}
func import(data : Dictionary = {"value" : ""}) :
	set_values(data.value)
	if data.has("settings") : set_settings(data.settings)

### MAIN OBJECT METHODS ###
func _on_gui_input(event: InputEvent) -> void :
	if disableAll : return
	if fixedControl : return
	if event is InputEventMouseButton :
		if event.double_click and event.button_index&MOUSE_BUTTON_MASK_LEFT :
			if $EditButton.visible : _on_edit_button_pressed()

### BUTTON METHODS ###
func _on_edit_button_pressed() -> void :
	$LineEdit.visible = true
	$LineEdit.grab_focus()
func _on_confirm_button_pressed() -> void :
	if $LineEdit.text != "" :
		text = $LineEdit.text
		values_changed.emit($LineEdit.text, self)
	else : $LineEdit.text = text
	$LineEdit.visible = false
func _on_cancel_button_pressed() -> void :
	$LineEdit.text = text
	$LineEdit.visible = false

### EDIT OBJECT METHODS ###
func _on_text_submitted(_new_text: String) : _on_confirm_button_pressed()
func _on_text_gui_input(event: InputEvent) :
	if event is InputEventKey :
		match event.keycode :
			KEY_ESCAPE: _on_cancel_button_pressed()
			KEY_TAB: _on_confirm_button_pressed()
			_: pass
func _on_text_focus_exited() :
	var local_position = get_viewport().get_mouse_position() - position
	if local_position.x >= 0 and local_position.x <= size.x :
		if local_position.y >=0 and local_position.y <= size.y : return
	_on_confirm_button_pressed()
