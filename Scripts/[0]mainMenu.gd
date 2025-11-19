extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Scenes/mainTest.tscn")


func _on_controls_pressed() -> void:
	print("Not Yet Implemented...")


func _on_quit_pressed() -> void:
	get_tree().quit()
