extends Control

@onready var display: Label = $VBoxContainer/display
@onready var preview: Label = $VBoxContainer/preview

var expression: String = ""
var preview_text: String = ""
var has_number: bool = false
var just_evaluated: bool = false

func on_number_pressed(number:int) -> void:
	print(number)
	if just_evaluated:
		display.text = "0"
		just_evaluated = false
		preview_text = ""
	var digit_count = display.text.replace(".", "").length()
	if digit_count >= 8:
		return
	if display.text != "0":
		display.text += str(number)
	else:
		display.text = str(number)
	has_number = true
	update_preview()

func on_symbol_pressed(symbol:String) -> void:
	match(symbol):
		"+", "-", "*", "/":
			just_evaluated = false
			commit_number()
			expression += symbol
			display.text = "0"
			preview_text += symbol
		"(": 
			expression += "("
			preview_text += symbol
		")":
			commit_number()
			expression += ")"
			preview_text += symbol
		"=":
			commit_number()
			var res = format_result(do_math(expression))
			
			display.text = res
			has_number = res != "error"
			expression = ""
			just_evaluated = true
		"percent":
			var n = float(display.text) / 100
			display.text = format_result(n)
		"pm":
			var n = float(display.text) * -1.0
			display.text = format_result(n)
		"del":
			if just_evaluated:
				display.text = "0"
				just_evaluated = false
			if display.text.length() > 1:
				display.text = display.text.left(display.text.length() - 1)
			else:
				display.text = "0"
		"ce":
			display.text = "0"
		"ac":
			has_number = false
			just_evaluated = false
			expression = ""
			display.text = "0"
			preview_text = ""
		".":
			if just_evaluated:
				display.text = "0"
				just_evaluated = false
				preview_text = ""
			if "." not in display.text: 
				display.text += "."
				has_number = true
			else:
				return
	update_preview()

func commit_number() -> void:
	if has_number:
		expression += str(float(display.text))
		preview_text += display.text
		has_number = false
		
func format_result(result) -> String:
	if result == null:
		return "error"
	if is_inf(result) or is_nan(result):
		return "error"
	if result == floorf(result):
		return str(int(result))
	return str(result)

func update_preview():
	var pending: String = display.text if has_number and not just_evaluated else ""
	preview.text = preview_text + pending

func do_math(formula: String):
	var expr = Expression.new()
	print(formula)
	var err = expr.parse(formula)
	if err != OK:
		push_error(expr.get_error_text())
		return null
	var result = expr.execute()
	if expr.has_execute_failed():
		return null
	return result
