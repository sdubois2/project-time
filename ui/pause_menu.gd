extends CanvasLayer


func _on_continue_button_pressed() -> void:
	print("pressed")
	GameManager.continue_game() # Replace with function body.
	queue_free()

func _on_main_menu_button_pressed() -> void:
	GameManager.main_menu() # Replace with function body.
	queue_free()
