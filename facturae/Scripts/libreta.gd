extends Node2D

@onready var persona: Sprite2D = $Persona
@onready var label_nombre: Label = $LabelNombre
@onready var label_apellido: Label = $LabelApellido

func _ready() -> void:
	if VariablesJugador.genero == "Hombre":
		persona.texture = preload("res://Assets/Escenas_inicio/Escena3/Hombre.png")
	else:
		persona.texture = preload("res://Assets/Escenas_inicio/Escena3/Mujer.png")
	
	label_nombre.text = VariablesJugador.nombre
	label_apellido.text = VariablesJugador.apellido


func _on_texture_button_pressed() -> void:
	self.visible = false
