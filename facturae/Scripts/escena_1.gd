extends Node2D

@onready var animations : AnimationPlayer = $Animations_escena1
signal siguienteEscena
func _ready() -> void:
	animations.play("Texto")
	
func _on_texture_button_pressed() -> void:
	hide()
	emit_signal("siguienteEscena")
	pass 
