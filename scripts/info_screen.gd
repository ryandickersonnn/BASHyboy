extends Control


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	pass
