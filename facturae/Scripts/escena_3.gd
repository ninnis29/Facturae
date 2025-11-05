extends Node2D
@onready var sprite_mujer : Sprite2D = $Mujer

func _on_button_change_pressed() -> void:
	sprite_mujer.visible = !sprite_mujer.visible
	pass 


func _on_flecha_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
