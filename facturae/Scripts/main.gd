extends Node2D

@onready var computer = $computer
@onready var facturas = $Facturas
@onready var continuar_btn = $computer/Continuar
@onready var personaje = $Personaje
@onready var label_pj = $Personaje/Label
@onready var musiquita = $musiquita
@onready var vidas_container = $Vidas  # Un HBoxContainer o similar con 3 sprites/texturas de facturas

var seleccion_jugador: String = "" 
var vidas: int = 3

func _ready() -> void:
	# Cargamos el archivo de música directamente desde la carpeta del proyecto
	var musica = load("res://Music/facturae_ost_1.wav")  # ruta exacta y extensión correcta
	if musica:
		var player = AudioStreamPlayer.new()    # creamos un AudioStreamPlayer en memoria
		add_child(player)                        # lo agregamos a la escena para que se reproduzca
		player.stream = musica                   # asignamos el archivof
		player.play()                            # reproducimos la música
	else:
		print("No se encontró el archivo de música")

func _on_computer_factura_a() -> void:
	facturas.mostrar_factura("A")
	seleccionar_opcion("A")

func _on_computer_factura_b() -> void:
	facturas.mostrar_factura("B")
	seleccionar_opcion("B")

func _on_computer_factura_c() -> void:
	facturas.mostrar_factura("C")
	seleccionar_opcion("C")

func _on_computer_continuar() -> void:
	gana_pierde()

func seleccionar_opcion(opcion: String) -> void:
	continuar_btn.visible = true
	seleccion_jugador = opcion

func gana_pierde() -> void:
	if seleccion_jugador == personaje.opcion_actual:
		label_pj.text = "¡Gracias! :D"
		continuar_partida()
	else:
		label_pj.text = "Eso no fue lo que pedí :C"
		perder_vida()

func perder_vida() -> void:
	vidas -= 1

	if vidas_container.get_child_count() >= vidas + 1:
		var vida_node = vidas_container.get_child(vidas) # selecciona la última vida activa
		vida_node.texture = preload("res://Assets/papel arrugado.png")  # cambia la textura

	if vidas <= 0:
		game_over()
	else:
		continuar_partida()

func continuar_partida() -> void:
	await get_tree().create_timer(1.0).timeout
	personaje.nueva_peticion()  # esto genera un nuevo diálogo aleatorio
	seleccion_jugador = ""
	continuar_btn.visible = false
	# Solo limpiamos feedback, no el pedido del personaje
	# feedback_label.text = ""  # si tenés un Label separado para mensajes

func game_over() -> void:
	label_pj.text = "¡Se acabaron las facturas! :("
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
