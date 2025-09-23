extends Node2D

@onready var factura_sprite = $Facturita
@onready var personaje: Node2D = $"../Personaje"

# Drags correctos e incorrectos
var drag_correcto_label: RichTextLabel = null
var drag_incorrecto_label: RichTextLabel = null

var factura_a = preload("res://Assets/Facturita_A.png")
var factura_b = preload("res://Assets/Facturita_B.png")
var factura_c = preload("res://Assets/Facturita_C.png")

# Constante para texto default de los slots
const SLOT_DEFAULT_TEXT := "CUIT"

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

# ------------------------------
# Mostrar factura y drags
# ------------------------------
func mostrar_factura(opcion: String) -> void:
	factura_sprite.visible = true
	match opcion:
		"A":
			factura_sprite.texture = factura_a
		"B":
			factura_sprite.texture = factura_b
		"C":
			factura_sprite.texture = factura_c

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
	var cuit_falso = generar_cuit_secundario()
	drag_incorrecto_label.actualizar_label(cuit_falso)
	drag_incorrecto_label.visible = true

func esconder_drags() -> void:
	if drag_correcto_label != null:
		drag_correcto_label.visible = false
	if drag_incorrecto_label != null:
		drag_incorrecto_label.visible = false

# ------------------------------
# Generar CUIT falso
# ------------------------------
func generar_cuit_secundario() -> String:
	var cuit_secundario = personaje.cuit_cliente
	while cuit_secundario == personaje.cuit_cliente:
		cuit_secundario = personaje.lista_cuits.pick_random()
	return cuit_secundario

# ------------------------------
# Resetear slot del drag
# ------------------------------
func reset_drag_slot() -> void:
	var slot = get_node_or_null("Slots/SlotCuitLabel")
	if slot != null:
		slot.text = SLOT_DEFAULT_TEXT
	else:
		push_error("SlotCuitLabel no encontrado para resetear")
