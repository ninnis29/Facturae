extends Node2D
@onready var sprite_mujer : Sprite2D = $Mujer
@onready var line_edit_nombre: LineEdit = $LineEditNombre
@onready var line_edit_apellido: LineEdit = $LineEditApellido
@onready var label_jefe: RichTextLabel = $RichTextLabel
@onready var animacion: AnimationPlayer = $Animations_escena3

func iniciarJuego() -> void:
	determinarGenero()
	VariablesJugador.nombre = line_edit_nombre.text
	VariablesJugador.apellido = line_edit_apellido.text
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func determinarGenero() -> void:
	if sprite_mujer.visible:
		VariablesJugador.genero = "Mujer"
	else:
		VariablesJugador.genero = "Hombre"

func _on_button_change_pressed() -> void:
	sprite_mujer.visible = !sprite_mujer.visible


func _on_flecha_pressed() -> void:
	if line_edit_nombre.text == "":
		animacion.play("DialogoError1")
		label_jefe.text = "Necesitas ingresar tu nombre antes de continuar!"
	elif line_edit_apellido.text == "":
		animacion.play("DialogoError2")
		label_jefe.text = "Necesitas ingresar tu apellido antes de continuar!"
	else:
		iniciarJuego()

func _on_escena_2_siguiente_escena_2() -> void:
	animacion.play("Dialogo")
