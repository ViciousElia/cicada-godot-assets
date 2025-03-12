class_name BBCodeValue
extends RichTextLabel

var disableAll : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var panelOverride = StyleBoxFlat.new()
	panelOverride.bg_color = Color("#000020dd")
	$BBCodeEdit.add_theme_stylebox_override("normal",panelOverride)
func _process(_delta: float) -> void:
	pass

func set_value(data : String):
	$BBCodeEdit.text = data
func get_value() -> String:
	return $BBCodeEdit.text
func set_disabled(disable : bool):
	$BBCodeEdit.editable = !disable
	disableAll = disable

func _on_cycle_pressed() -> void:
	$BBCodeEdit.visible = !$BBCodeEdit.visible
func _on_meta_clicked(meta: Variant) -> void:
	# MAYBE TODO : add code to allow function execution.
	var unVary = str(meta)
	var urlRegex = RegEx.new()
	urlRegex.compile('^(ftp|http|https)://[^ "]+$')
	if meta is String:
		var result = urlRegex.search(meta)
		if result : OS.shell_open(meta)
		else : print("invalid URL")
	else :
		var result = urlRegex.search(unVary)
		if result : OS.shell_open(unVary)
		else : print("invalid URL")

func _on_code_changed() -> void:
	text = $BBCodeEdit.text
