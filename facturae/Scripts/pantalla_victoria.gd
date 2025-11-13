extends Node2D
@onready var animacion : AnimationPlayer = $AnimationEscenaVictoria

func _ready() -> void:
	animacion.play("Dialogo")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/pantalla_inicio.tscn")
