extends Control

@onready var display: Label = $VBoxContainer/display

var total = 0
var last_symbol = ""

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
	

func on_symbol_pressed(symbol:String) -> void:
	match(symbol):
		"+":
			do_math()
			last_symbol = symbol
		"-":
			do_math()
			last_symbol = symbol
		"*":
			do_math()
			last_symbol = symbol
		"/":
			do_math()
			last_symbol = symbol
		"=":
			do_math()
			last_symbol = ""
			display.text = str(total)
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
			total = 0
			last_symbol = ""
		".":
			if "." not in display.text: 
				display.text += "."
			else:
				pass
		
			
	print(symbol)

func do_math():
	var n = float(display.text)
	 
	match(last_symbol):
		"":
			total = n
		"+":
			total += n
		"-":
			total -= n
		"*":
			total *= n
		"/":
			total /= n
	display.text = "0"
	print("total " +str(total))
	
