extends Node2D

@onready var dialogo1 : Sprite2D = $Dialogo
@onready var dialogo2 : Sprite2D = $Dialogo2
@onready var dialogo3 : Sprite2D = $Dialogo3
@onready var brillo_pc : Sprite2D = $BrilloPc
@onready var brillo_cuaderno : Sprite2D = $BrilloCuaderno
@onready var brillo_vidas: Sprite2D = $BrilloVidas
@onready var animaciones: AnimationPlayer = $Animations_escena2
@onready var sonido: AudioStreamPlayer2D = $Sonido
signal siguienteEscena2

var dialogo = ["res://SFX/Jefe_1.wav", "res://SFX/Jefe_2.wav", "res://SFX/Jefe_3.wav", "res://SFX/Jefe_4.wav"]
var dialogos_y_brillos: Array = []
var indice: int = 0

func _on_escena_1_siguiente_escena() -> void:
	instanciar_dialogos_y_brillos()

func instanciar_dialogos_y_brillos():
	dialogos_y_brillos = [
		{"texto": dialogo1, "brillo": brillo_pc, "animacion": "Dialogo1"},
		{"texto": dialogo2, "brillo": brillo_cuaderno, "animacion": "Dialogo2"},
		{"texto": dialogo3, "brillo": brillo_vidas, "animacion": "Dialogo3"}
	]
	
	for i in dialogos_y_brillos:
		i["texto"].visible = false
		i["brillo"].visible = false
	
	mostrar_dialogo_actual()

func mostrar_dialogo_actual():
	var actual = dialogos_y_brillos[indice]
	actual["texto"].visible = true
	actual["brillo"].visible = true
	
	if actual.has("animacion"):
		animaciones.play(actual["animacion"])
	
	sonido.stream = load(dialogo[randi_range(0, 3)])
	sonido.play()


func _on_flecha_pressed() -> void:
	dialogos_y_brillos[indice]["texto"].visible = false
	dialogos_y_brillos[indice]["brillo"].visible = false
	indice += 1

	if indice < dialogos_y_brillos.size():
		mostrar_dialogo_actual()
	else:
		hide()
		emit_signal("siguienteEscena2")



	
