extends Node2D



@onready var computer = $computer
@onready var facturas = $Facturas
@onready var continuar_btn = $computer/Continuar
@onready var personaje = $Personaje
@onready var label_pj = $Personaje/Label
@onready var musiquita = $musiquita
@onready var vidas_container = $Vidas  # Un HBoxContainer o similar con 3 sprites/texturas de facturas
@onready var libreta: Node2D = $libreta


var seleccion_jugador: String = "" 
var vidas: int = 3
var cantidad_clientes : int = 0

func _ready():
	# Reproduce la musica al ser invocado. Si se usa autoplay se buguea cuando se reinicia la escena.
	musiquita.reproducirMusica()


func mostrarDatosJugador():
	print("Nombre: ", VariablesJugador.nombre)
	print("Apellido: ", VariablesJugador.apellido)
	print("Genero: ", VariablesJugador.genero)

func _on_computer_factura_a() -> void:
	facturas.mostrarDatosDeFacturaSeleccionada("A")
	seleccionarModeloDeFactura("A")

func _on_computer_factura_b() -> void:
	facturas.mostrarDatosDeFacturaSeleccionada("B")
	seleccionarModeloDeFactura("B")

func _on_computer_factura_c() -> void:
	facturas.mostrarDatosDeFacturaSeleccionada("C")
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
	if cantidad_clientes < 4:
		await get_tree().create_timer(1.0).timeout
		personaje.generarNuevoCliente()  # esto genera un nuevo diálogo aleatorio
		seleccion_jugador = ""
		# Solo limpiamos feedback, no el pedido del personaje
		# feedback_label.text = ""  # si tenés un Label separado para mensajes
		facturas.esconderDatosDeFactura()
	else:
		cierreDia()

func finalizarPartida() -> void:
	label_pj.text = "Quiero hablar con tu jefe"
	await get_tree().create_timer(3.0).timeout
	musiquita.frenarMusica() # Si o si tiene que estar esto sino se buguea al reiniciar :) 
	get_tree().reload_current_scene()

func on_correcto() -> void:
	facturas.esconderDatosDeFactura()
	await get_tree().create_timer(2.0).timeout
	continuarPartida()

func on_pierde_vida() -> void:
	facturas.esconderDatosDeFactura()
	await get_tree().create_timer(2.0).timeout
	perderVida()

func cierreDia() -> void:
	print("Se cerro el dia")


func _on_libreta_button_pressed() -> void:
	libreta.visible = !libreta.visible
