extends Node2D

#var player_in_range = false
#
#const lines: Array[String] = [
	#"hey there...",
	#"im your gramma estrana.",
	#"mk go play"
#]
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body.name)
	#if body.name == "CharacterBody2D":
		#player_in_range = true
		#print("Enter")
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.name == "CharacterBody2D":
		#player_in_range = false
		#print("Exit")
#
#func _process(delta: float) -> void:
	#if player_in_range:
		#if Input.is_action_just_pressed("Interact"):
			#DialogManager.start_dialog(global_position, lines)
