extends Control

@onready var display: Label = $VBoxContainer/display

#var total = 0
#var last_symbol = ""
var expression = ""
var has_number = false

func _ready() -> void:
	pass # Replace with function body.

func on_number_pressed(number:int) -> void:
	print(number)
	var digit_count = display.text.replace(".", "").length()
	if digit_count >= 8:
		return
	if display.text != "0":
		display.text += str(number)
	else:
		display.text = str(number)
	has_number = true
	

func on_symbol_pressed(symbol:String) -> void:
	match(symbol):
		"+", "-", "*", "/":
			commit_number()
			expression += symbol
			display.text = "0"
		"(": 
			expression += "("
		")": 
			expression += ")"
		"=":
			commit_number()
			var res = format_result(do_math(expression))
			
			display.text = res
			has_number = true
			expression = ""
		"percent":
			var n = float(display.text) / 100
			display.text = str(n)
		"pm":
			var n = float(display.text) * -1.0
			display.text = str(n)
		"del":
			if display.text.length() > 1:
				display.text = display.text.left(display.text.length() - 1)
			else:
				display.text = "0"
		"ce":
			display.text = "0"
		"ac":
			display.text = "0"
			expression = ""
		".":
			if "." not in display.text: 
				display.text += "."
				has_number = true
			else:
				return
		
			
	print(symbol)

func commit_number() -> void:
	if has_number:
		expression += str(float(display.text))
		has_number = false
		
func format_result(result) -> String:
	if result == null:
		return "error"
	if is_inf(result) or is_nan(result):
		return "error"
	if result == floorf(result):
		return str(int(result))
	return str(result)

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
