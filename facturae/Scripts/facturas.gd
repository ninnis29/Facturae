extends Node2D

@onready var factura_sprite = $Facturita
@onready var personaje: Node2D = $"../Personaje"
@onready var main = $"../"

# Drags correctos e incorrectos
var drag_correcto_label: RichTextLabel = null
var drag_incorrecto_label: RichTextLabel = null

@onready var boton_continuar = get_node("/root/Main/computer/Continuar")
@onready var slot_cuit_label: RichTextLabel = $Slots/CuitSlotPanel/CuitSlotLabel
@onready var cuit_slot_panel: Panel = $Slots/CuitSlotPanel
@onready var marker_1: Marker2D = $Marker1
@onready var marker_2: Marker2D = $Marker2

signal correcto
signal pierde_vida


var factura_a = preload("res://Assets/Facturita_A.png")
var factura_b = preload("res://Assets/Facturita_B.png")
var factura_c = preload("res://Assets/Facturita_C.png")
var seleccion_factura = ""
var cliente_factura = ""
var current_cuit_in_slot = ""


func _ready() -> void:
	# Inicialmente ocultamos todo
	$Drags.visible = false
	$Slots.visible = false
	
	# Esperamos un frame para asegurar que los nodos hijos estén listos
	await get_tree().process_frame
	
	# Asignamos los drags
	drag_correcto_label = get_node_or_null("Drags/CuitDragLabel")
	drag_incorrecto_label = get_node_or_null("Drags/CuitDragLabel2")
	
	if drag_correcto_label == null or drag_incorrecto_label == null:
		push_error("No se encontraron los drags en la escena Facturas!")
	
	# Conectamos el botón
	boton_continuar.pressed.connect(_on_boton_continuar_pressed)
	

# ------------------------------
# Botón continuar -> validación
# ------------------------------
func _on_boton_continuar_pressed() -> void:
	print("Drag incorrecto:")
	print(drag_incorrecto_label.text)
	print("Current label:")
	print(cuit_slot_panel.current_label)
	
	# Slot vacío
	if cuit_slot_panel.current_label == "":
		print("No se puede continuar: el CUIT está vacío.")
		
	# Validación correcta
	elif cuit_slot_panel.current_label == personaje.cuit_cliente and seleccion_factura == cliente_factura:
		print("Factura correcta ✅. Pasando al siguiente cliente...")
		personaje.mood_cliente = "Feliz"
		personaje.actualizar_sprite()
		main.on_correcto()
		
	else:
		print("Factura incorrecta ❌. Perdés una vida!")
		personaje.mood_cliente = "Enojado"
		personaje.actualizar_sprite()
		main.on_pierde_vida()
		
		# Aquí restás vida o das feedback, pero NO generás nuevo cliente
	
	reset_drag_slot()


# ------------------------------
# Mostrar factura y drags
# ------------------------------
func mostrar_factura(opcion: String) -> void:
	factura_sprite.visible = true
	match opcion:
		"A":
			factura_sprite.texture = factura_a
			seleccion_factura = "A"
			
		"B":
			factura_sprite.texture = factura_b
			seleccion_factura = "B"
			
		"C":
			factura_sprite.texture = factura_c
			seleccion_factura = "C"
	
	

	$Drags.visible = true
	$Slots.visible = true
	
	
	
	# Generar drags al mostrar la factura
	mostrar_drags()

func esconder_factura() -> void:
	factura_sprite.visible = false
	$Drags.visible = false
	$Slots.visible = false
	esconder_drags()
	reset_drag_slot()

# ------------------------------
# Actualizar información del drag correcto
# ------------------------------
func actualizar_informacion(cuit_cliente: String) -> void:
	if drag_correcto_label == null:
		drag_correcto_label = get_node_or_null("Drags/CuitDragLabel")
	if drag_correcto_label != null:
		drag_correcto_label.actualizar_label(cuit_cliente)
	else:
		push_error("drag_correcto_label es null al llamar actualizar_informacion")

# ------------------------------
# DRAGS
# ------------------------------
func mostrar_drags() -> void:
	if drag_correcto_label == null or drag_incorrecto_label == null:
		return
	
	# Drag correcto
	drag_correcto_label.actualizar_label(personaje.cuit_cliente)
	drag_correcto_label.visible = true

	# Drag incorrecto: solo generamos CUIT diferente del cliente
	var cuit_falso = personaje.cuit_secundario
	drag_incorrecto_label.actualizar_label(cuit_falso)
	drag_incorrecto_label.visible = true
	drags_random_position()
	

func drags_random_position() -> void:
	print("random pos")
	
	match randi_range(1,2):
		1:
			drag_correcto_label.position = marker_1.position
			drag_incorrecto_label.position = marker_2.position
		2:
			drag_incorrecto_label.position = marker_1.position
			drag_correcto_label.position = marker_2.position


func esconder_drags() -> void:
	if drag_correcto_label != null:
		drag_correcto_label.visible = false
	if drag_incorrecto_label != null:
		drag_incorrecto_label.visible = false

# ------------------------------
# Generar CUIT falso
# ------------------------------
#func generar_cuit_secundario() -> String:
	#var cuit_secundario = personaje.cuit_cliente
	#while cuit_secundario == personaje.cuit_cliente:
		#cuit_secundario = personaje.lista_cuits.pick_random()
	#return cuit_secundario

# ------------------------------
# Resetear slot del drag
# ------------------------------
func reset_drag_slot() -> void:
	if slot_cuit_label != null:
		slot_cuit_label.text = ""
	
	else:
		push_error("SlotCuitLabel no encontrado para resetear")
