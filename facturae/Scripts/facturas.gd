extends Node2D

@onready var factura_sprite = $Facturita
@onready var personaje: Node2D = $"../Personaje"
@onready var main = $"../"

# Drags correctos e incorrectos de CUIT
var drag_correcto_label: RichTextLabel = null
var drag_incorrecto_label: RichTextLabel = null
# Drags de Nombre
var drag_correcto_nombre_label: RichTextLabel = null
var drag_incorrecto_nombre_label: RichTextLabel = null
# Drags de Domicilio
var drag_correcto_domicilio_label: RichTextLabel = null
var drag_incorrecto_domicilio_label: RichTextLabel = null

@onready var boton_continuar = get_node("/root/Main/computer/Continuar")
@onready var slot_cuit_label: RichTextLabel = $Slots/CuitSlotPanel/CuitSlotLabel
@onready var cuit_slot_panel: Panel = $Slots/CuitSlotPanel
@onready var slot_nombre_label: RichTextLabel = $Slots/NombreSlotPanel/NombreSlotLabel
@onready var nombre_slot_panel: Panel = $Slots/NombreSlotPanel
@onready var slot_domicilio_label: RichTextLabel = $Slots/DomicilioSlotPanel/DomicilioSlotLabel
@onready var domicilio_slot_panel: Panel = $Slots/DomicilioSlotPanel
@onready var marker_1: Marker2D = $Marker1
@onready var marker_2: Marker2D = $Marker2
@onready var marker_3: Marker2D = $Marker3
@onready var marker_4: Marker2D = $Marker4
@onready var marker_5: Marker2D = $Marker5
@onready var marker_6: Marker2D = $Marker6
@onready var marker_7: Marker2D = $Marker7
@onready var marker_8: Marker2D = $Marker8

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
	
	drag_correcto_nombre_label = get_node_or_null("Drags/NombreDragLabel")
	drag_incorrecto_nombre_label = get_node_or_null("Drags/NombreDragLabel2")
	
	drag_correcto_domicilio_label = get_node_or_null("Drags/DomicilioDragLabel")
	drag_incorrecto_domicilio_label = get_node_or_null("Drags/DomicilioDragLabel2")
	
	if drag_correcto_label == null or drag_incorrecto_label == null:
		push_error("No se encontraron los drags de CUIT en la escena Facturas!")
		
	if drag_correcto_nombre_label == null or drag_incorrecto_nombre_label == null:
		push_error("No se encontraron los drags de NOMBRE en la escena Facturas!")
		
	if drag_correcto_domicilio_label == null or drag_incorrecto_domicilio_label == null:
		push_error("No se encontraron los drags de DOMICILIO en la escena Facturas!")
	
	# Conectamos el botón
	boton_continuar.pressed.connect(_on_boton_continuar_pressed)
	
# Botón continuar -> validación
func _on_boton_continuar_pressed() -> void:
	print("Drag incorrecto:")
	print(drag_incorrecto_label.text)
	print("Current CUIT label:")
	print(cuit_slot_panel.current_label)
	print("Current Nombre label:")
	print(slot_nombre_label.text)
	print("Current Domicilio label:")
	print(slot_domicilio_label.text)

	# 1) Slots vacíos
	if cuit_slot_panel.current_label == "" and slot_nombre_label.text == "":
		print("No se puede continuar: Datos incompletos.")
		return
	
	# 3) Validación correcta
	elif slot_nombre_label.text == personaje.nombre_cliente and cuit_slot_panel.current_label == personaje.cuit_cliente and domicilio_slot_panel.current_label == personaje.domicilio_cliente and seleccion_factura == cliente_factura:
		print("Factura correcta ✅. Pasando al siguiente cliente...")
		personaje.mood_cliente = "Feliz"
		personaje.actualizar_sprite()
		main.on_correcto()
	
	# 4) En cualquier otro caso → incorrecto
	else:
		if slot_nombre_label.text != personaje.nombre_cliente:
			print("Nombre incorrecto ❌. Perdés una vida!")
		elif cuit_slot_panel.current_label != personaje.cuit_cliente:
			print("CUIT incorrecto ❌. Perdés una vida!")
		elif domicilio_slot_panel.current_label != personaje.domicilio_cliente:
			print("Domicilio incorrecto ❌. Perdés una vida!")
		elif seleccion_factura == cliente_factura:
			print("Factura incorrecta ❌. Perdés una vida!")
		else:
			print("Datos solicitados incorrectos ❌. Perdés una vida!")
		personaje.mood_cliente = "Enojado"
		personaje.actualizar_sprite()
		main.on_pierde_vida()

	# 5) Reset de slots
	reset_drag_slot()

# Mostrar factura y drags
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
	mostrar_drags_nombre()
	mostrar_drags_domicilio()
	
func esconder_factura() -> void:
	factura_sprite.visible = false
	$Drags.visible = false
	$Slots.visible = false
	esconder_drags()
	reset_drag_slot()

# Actualizar información del drag correcto
func actualizar_informacion(cuit_cliente: String) -> void:
	if drag_correcto_label == null:
		drag_correcto_label = get_node_or_null("Drags/CuitDragLabel")
	if drag_correcto_label != null:
		drag_correcto_label.actualizar_label(cuit_cliente)
	else:
		push_error("drag_correcto_label es null al llamar actualizar_informacion")

# DRAGS
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
	
func mostrar_drags_nombre() -> void:
	if drag_correcto_nombre_label == null or drag_incorrecto_nombre_label == null:
		return
	# Drag correcto → el nombre real
	drag_correcto_nombre_label.text = personaje.nombre_cliente
	drag_correcto_nombre_label.visible = true
	# Drag incorrecto → el nombre real
	var nombre_secundario = personaje.nombre_secundario
	drag_incorrecto_nombre_label.actualizar_label(nombre_secundario)
	drag_incorrecto_nombre_label.visible = true
	drags_nombre_random_position()

func mostrar_drags_domicilio() -> void:
	if drag_correcto_domicilio_label == null or drag_incorrecto_domicilio_label == null:
		return
	# Drag correcto → el domicilio real
	drag_correcto_domicilio_label.text = personaje.domicilio_cliente
	drag_correcto_domicilio_label.visible = true
	# Drag incorrecto → el domicilio real
	var domicilio_secundario = personaje.domicilio_secundario
	drag_incorrecto_domicilio_label.actualizar_label(domicilio_secundario)
	drag_incorrecto_domicilio_label.visible = true
	drags_domicilio_random_position()

func drags_random_position() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_label.position = marker_3.position
			drag_incorrecto_label.position = marker_4.position
		2:
			drag_incorrecto_label.position = marker_3.position
			drag_correcto_label.position = marker_4.position

func drags_nombre_random_position() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_nombre_label.position = marker_1.position
			drag_incorrecto_nombre_label.position = marker_2.position
		2:
			drag_incorrecto_nombre_label.position = marker_1.position
			drag_correcto_nombre_label.position = marker_2.position
			
func drags_domicilio_random_position() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_domicilio_label.position = marker_5.position
			drag_incorrecto_domicilio_label.position = marker_6.position
		2:
			drag_incorrecto_domicilio_label.position = marker_5.position
			drag_correcto_domicilio_label.position = marker_6.position

func esconder_drags() -> void:
	# Nombre
	if drag_correcto_nombre_label != null:
		drag_correcto_nombre_label.visible = false
	if drag_incorrecto_nombre_label != null:
		drag_incorrecto_nombre_label.visible = false
	# Cuit
	if drag_correcto_label != null:
		drag_correcto_label.visible = false
	if drag_incorrecto_label != null:
		drag_incorrecto_label.visible = false
	# Domicilio
	if drag_correcto_domicilio_label != null:
		drag_correcto_domicilio_label.visible = false
	if drag_incorrecto_domicilio_label != null:
		drag_incorrecto_domicilio_label.visible = false
	
# Resetear slot del drag
func reset_drag_slot() -> void:
	if slot_cuit_label != null:
		slot_cuit_label.text = ""
	else:
		push_error("SlotCuitLabel no encontrado para resetear")
	if slot_nombre_label != null:
		slot_nombre_label.text = ""
	else:
		push_error("SlotNombreLabel no encontrado para resetear")
	if slot_domicilio_label != null:
		slot_domicilio_label.text = ""
	else:
		push_error("SlotDomicilioLabel no encontrado para resetear")

# Generar CUIT falso
#func generar_cuit_secundario() -> String:
	#var cuit_secundario = personaje.cuit_cliente
	#while cuit_secundario == personaje.cuit_cliente:
		#cuit_secundario = personaje.lista_cuits.pick_random()
	#return cuit_secundario
