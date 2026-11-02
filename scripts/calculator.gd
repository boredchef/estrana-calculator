extends Control

@onready var display: Label = $VBoxContainer/display
@onready var preview: Label = $VBoxContainer/preview

var expression: String = ""
var preview_text: String = ""
var has_number: bool = false
var has_symbol: bool = false
var last_symbol: String = ""
var just_evaluated: bool = false
var open_parens: int = 0

func on_number_pressed(number:int) -> void:
	print(number)
	if just_evaluated:
		display.text = "0"
		just_evaluated = false
		preview_text = ""
	has_symbol = false
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
			if has_symbol:
				expression = expression.left(expression.length() - 1)
				preview_text = preview_text.left(preview_text.length() - 1)
			else: 
				commit_number()
			has_symbol = true
			expression += symbol
			preview_text += symbol
			display.text = "0"
			
		"(": 
			if has_number:
				return
			expression += "("
			open_parens += 1
			preview_text += symbol
			has_symbol = false
		")":
			if open_parens == 0:
				return
			open_parens -= 1
			commit_number()
			expression += ")"
			preview_text += symbol
			display.text = "0"
			has_symbol = false
		"=":
			commit_number()
			expression += ")".repeat(open_parens)
			if has_symbol:
				expression = expression.left(expression.length() - 1)
			preview_text = ""
			var res = format_result(do_math(expression))
			
			display.text = res
			has_number = res != "error"
			expression = ""
			just_evaluated = true
			has_symbol = false
			open_parens = 0
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
			has_symbol = false
			just_evaluated = false
			open_parens = 0
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
				has_symbol = false
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
