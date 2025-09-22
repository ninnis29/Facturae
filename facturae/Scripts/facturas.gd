extends Node2D

@onready var factura_sprite = $Facturita
@onready var personaje: Node2D = $"../Personaje"

# Nodo CuitDragLabel: lo buscamos dinámicamente para evitar null si la escena está instanciada
var cuit_drag_label: RichTextLabel = null

var factura_a = preload("res://Assets/Facturita_A.png")
var factura_b = preload("res://Assets/Facturita_B.png")
var factura_c = preload("res://Assets/Facturita_C.png")

func _ready() -> void:
	await get_tree().process_frame  # espera un frame
	cuit_drag_label = get_node("Drags/CuitDragLabel")
	if cuit_drag_label == null:
		push_error("No se encontró CuitDragLabel en la escena Facturas!")
	
	# Si querés, probamos actualizar al inicio
	# actualizar_informacion("27-45219605-3")

func mostrar_factura(opcion: String) -> void:
	factura_sprite.visible = true
	match opcion:
		"A":
			factura_sprite.texture = factura_a
		"B":
			factura_sprite.texture = factura_b
		"C":
			factura_sprite.texture = factura_c

func esconder_factura() -> void:
	factura_sprite.visible = false

func actualizar_informacion(cuit_cliente: String) -> void:
	cuit_drag_label = get_node("Drags/CuitDragLabel")
	if cuit_drag_label != null:
		cuit_drag_label.actualizar_label(cuit_cliente)
	else:
		push_error("cuit_drag_label es null al llamar actualizar_informacion")

	
