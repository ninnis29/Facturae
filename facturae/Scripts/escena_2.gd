extends Node2D
@onready var dialogo1 : Sprite2D = $Dialogo
@onready var dialogo2 : Sprite2D = $Dialogo2
@onready var dialogo3 : Sprite2D = $Dialogo3
@onready var brillo_pc : Sprite2D = $BrilloPc
@onready var brillo_cuaderno : Sprite2D = $BrilloCuaderno
@onready var brillo_vidas: Sprite2D = $BrilloVidas
@onready var animaciones: AnimationPlayer = $AnimationDialogos
var dialogos_y_brillos: Array = []
var indice: int = 0


func _ready() -> void:
	instanciar_dialogos_y_brillos()

func instanciar_dialogos_y_brillos():
	dialogos_y_brillos = [
		{"texto": dialogo1, "brillo": brillo_pc},
		{"texto": dialogo2, "brillo": brillo_cuaderno},
		{"texto": dialogo3, "brillo": brillo_vidas}
	]
	for i in dialogos_y_brillos:
		i["texto"].visible = false 
		i["brillo"].visible = false
	dialogos_y_brillos[indice].texto.visible = true
	dialogos_y_brillos[indice].brillo.visible = true

func _on_flecha_pressed() -> void:
	dialogos_y_brillos[indice].texto.visible = false
	dialogos_y_brillos[indice].brillo.visible = false
	
	indice += 1
	
	if indice < dialogos_y_brillos.size():
		dialogos_y_brillos[indice].texto.visible = true
		dialogos_y_brillos[indice].brillo.visible = true
	else:
		hide()
	
