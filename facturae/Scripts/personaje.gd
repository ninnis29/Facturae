extends Node2D
@onready var caja_dialogo = $Label

func _ready() -> void:
	dialogo_random()

var dialogos = {
	"A": ["Podria darme la factura A?", "Deme factura A"],
	"B": ["Factura B, por favor.", "Buenos dias, factura B?"],
	"C": ["Hola! Factura C!", "Qué tal? factura C?"]
}

var opcion_actual = ""

func dialogo_random() -> void:
	var opciones = ["A", "B", "C"]
	opcion_actual = opciones.pick_random()
	var linea_dialogo = dialogos[opcion_actual].pick_random()
	caja_dialogo.text = linea_dialogo
	pass
	
func nueva_peticion() -> void:
	dialogo_random()
