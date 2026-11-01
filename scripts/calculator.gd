extends Control

@onready var display: Label = $VBoxContainer/display

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func on_number_pressed(number:int) -> void:
	print(number)

func on_symbol_pressed(symbol:String) -> void:
	print(symbol)
