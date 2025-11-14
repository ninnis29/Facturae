extends Node2D
@onready var sonido: AudioStreamPlayer2D = $Sonido
@onready var animations : AnimationPlayer = $Animations_escena1
signal siguienteEscena

var dialogo = ["res://SFX/Jefe_1.wav", "res://SFX/Jefe_2.wav", "res://SFX/Jefe_3.wav", "res://SFX/Jefe_4.wav"]

func _ready() -> void:
	animations.play("Texto")
	
	sonido.stream = load(dialogo[randi_range(0, 3)])
	sonido.play()
	
func _on_texture_button_pressed() -> void:
	hide()
	emit_signal("siguienteEscena")
	pass 
