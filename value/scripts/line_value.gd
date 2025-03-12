class_name LineValue
extends HBoxContainer

signal value_changed(value : String, me : LineValue)
signal case_changed(value : int, me : LineValue)

var disableAll : bool = false
var fixedCase : bool = false

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func initialise(value : String, case : int = 0, fixed : bool = false):
	$LineEdit.text = value
	$TextCaseButton.initialise(case,fixed)
	fixedCase = fixed

func set_value(data : String):
	$LineEdit.text = data
func get_value() -> String:
	return $LineEdit.text
func set_case(data : int):
	$TextCaseButton.select(data)
func get_case() -> int:
	return $TextCaseButton.selected
func set_disabled(disable : bool):
	if fixedCase : $TextCaseButton.disabled = true
	else : $TextCaseButton.disabled = disable
	$LineEdit.editable = !disable
	disableAll = disable

func validate_case(queryText : String) -> String:
	if $TextCaseButton.selected == 0 : return queryText
	var formattedText = queryText
	match $TextCaseButton.selected:
		1: # snake_case
			var locRegex = RegEx.create_from_string("[^\\s\\w]|[\\d]")
			formattedText = locRegex.sub(formattedText,"",true).to_snake_case()
		2: # camelCase
			var locRegex = RegEx.create_from_string("[^\\s\\w]")
			formattedText = locRegex.sub(formattedText,"",true).replace("_"," ").lstrip("0123456789").to_camel_case()
		3: # PascalCase
			var locRegex = RegEx.create_from_string("[^\\s\\w]|_")
			formattedText = locRegex.sub(formattedText.replace("_"," "),"",true).lstrip("0123456789").to_pascal_case()
		4: # filename.case
			var locRegex = RegEx.create_from_string("[^\\s\\w.]")
			formattedText = locRegex.sub(formattedText,"",true).validate_filename()
		5: # 8.3 case
			var locRegex = RegEx.create_from_string("[^\\w.]|_")
			formattedText = locRegex.sub(formattedText,"",true)
			formattedText = formattedText.lstrip(".").to_upper()
			if formattedText.length() > 8:
				if formattedText.find(".") < 0 : formattedText = formattedText.insert(8,".")
			var firstDot = formattedText.find(".")
			if firstDot > 0 : 
				formattedText = RegEx.create_from_string("[.]").sub(formattedText,"",true,firstDot+1)
			if firstDot > 8 :
				formattedText = formattedText.replace(".","").insert(8,".")
			if formattedText.length() > 12:
				formattedText = formattedText.erase(12,256)
		_: pass
	return formattedText

func _on_text_changed(new_text: String) -> void:
	var updateText = validate_case(new_text)
	if updateText != new_text :
		var caretPosition = $LineEdit.caret_column
		$LineEdit.text = updateText
		$LineEdit.caret_column = caretPosition
		value_changed.emit(updateText,self)
	else : value_changed.emit(new_text,self)
func _on_case_changed(idx: int, _me: TextCaseButton) -> void:
	var updateText = validate_case($LineEdit.text)
	if updateText != $LineEdit.text :
		var caretPosition = $LineEdit.caret_column
		$LineEdit.text = updateText
		$LineEdit.caret_column = caretPosition
		value_changed.emit(updateText,self)
	case_changed.emit(idx,self)
