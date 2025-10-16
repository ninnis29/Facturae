extends Node2D

@onready var computer = $computer
@onready var facturas = $Facturas
@onready var continuar_btn = $computer/Continuar
@onready var personaje = $Personaje
@onready var label_pj = $Personaje/Label
@onready var musiquita = $musiquita
@onready var vidas_container = $Vidas  # Un HBoxContainer o similar con 3 sprites/texturas de facturas

signal correcto
signal pierde_vida


var seleccion_jugador: String = "" 
var vidas: int = 3

func _ready():
	# Reproduce la musica al ser invocado. Si se usa autoplay se buguea cuando se reinicia la escena.
	musiquita.reproducirMusica()


func _on_computer_factura_a() -> void:
	facturas.mostrarDatosDeFactura("A")
	seleccionarModeloDeFactura("A")

func _on_computer_factura_b() -> void:
	facturas.mostrarDatosDeFactura("B")
	seleccionarModeloDeFactura("B")

func _on_computer_factura_c() -> void:
	facturas.mostrarDatosDeFactura("C")
	seleccionarModeloDeFactura("C")

func seleccionarModeloDeFactura(opcion: String) -> void:
	continuar_btn.visible = true
	seleccion_jugador = opcion


func perderVida() -> void:

	vidas -= 1


	if vidas_container.get_child_count() >= vidas + 1:
		var vida_node = vidas_container.get_child(vidas) # selecciona la última vida activa
		vida_node.texture = preload("res://Assets/papel arrugado.png")  # cambia la textura

	if vidas <= 0:
		finalizarPartida()
		facturas.esconderDatosDeFactura()
	else:
		continuarPartida()

func continuarPartida() -> void:
	await get_tree().create_timer(1.0).timeout
	personaje.generarNuevoCliente()  # esto genera un nuevo diálogo aleatorio
	seleccion_jugador = ""
	# Solo limpiamos feedback, no el pedido del personaje
	# feedback_label.text = ""  # si tenés un Label separado para mensajes
	facturas.esconderDatosDeFactura()

func finalizarPartida() -> void:
	label_pj.text = "¡Se acabaron las facturas! :("
	await get_tree().create_timer(2.0).timeout
	musiquita.frenarMusica() # Si o si tiene que estar esto sino se buguea al reiniciar :) 
	get_tree().reload_current_scene()


func on_correcto() -> void:
	facturas.esconderDatosDeFactura()
	label_pj.text = "¡Gracias! :D"
	await get_tree().create_timer(2.0).timeout
	continuarPartida()

func on_pierde_vida() -> void:
	facturas.esconderDatosDeFactura()
	label_pj.text = "Eso no fue lo que pedí :C"
	await get_tree().create_timer(2.0).timeout
	perderVida()
