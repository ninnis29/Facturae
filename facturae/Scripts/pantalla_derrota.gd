extends Node2D
@onready var animacion : AnimationPlayer = $AnimationEscenaDerrota
@onready var sonido: AudioStreamPlayer2D = $Sonido

func _ready() -> void:
	animacion.play("Dialogo")
	sonido.stream = load("res://SFX/Jefe_Enojado.wav")
	sonido.play()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/pantalla_inicio.tscn")
