extends Node2D

@onready var computer = $computer
@onready var facturas = $Facturas
@onready var continuar_btn = $computer/Continuar
@onready var personaje = $Personaje
@onready var label_pj = $Personaje/Label
@onready var musiquita = $musiquita
var seleccion_jugador: String = "" 

func _on_computer_factura_a() -> void:
	facturas.mostrar_factura("A")
	seleccionar_opcion("A")
	pass 

func _on_computer_factura_b() -> void:
	facturas.mostrar_factura("B")
	seleccionar_opcion("B")
	pass

func _on_computer_factura_c() -> void:
	facturas.mostrar_factura("C")
	seleccionar_opcion("C")
	pass 

func _on_computer_continuar() -> void:
	gana_pierde()
	reiniciar_partida()
	pass 
	
func seleccionar_opcion(opcion):
	continuar_btn.visible = true
	seleccion_jugador = opcion

func gana_pierde():
	if seleccion_jugador == personaje.opcion_actual:
		label_pj.text = "Gracias! :D"
	else:
		label_pj.text = "Eso no fue lo que pedi :C"

func reiniciar_partida():
	await get_tree().create_timer(0.8).timeout
	get_tree().reload_current_scene()
