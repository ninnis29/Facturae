extends Node2D


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/escenas_inicio.tscn")
	pass 


func _on_config_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass 


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/creditos.tscn")
