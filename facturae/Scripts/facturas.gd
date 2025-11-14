extends Node2D

@onready var factura_sprite = $Facturita
@onready var personaje: Node2D = $"../Personaje"
@onready var main = $"../"
@onready var boton_continuar = get_node("/root/Main/computer/Continuar")
@onready var slot_cuit_label: RichTextLabel = $Slots/CuitSlotPanel/CuitSlotLabel
@onready var cuit_slot_panel: Panel = $Slots/CuitSlotPanel
@onready var slot_nombre_label: RichTextLabel = $Slots/NombreSlotPanel/NombreSlotLabel
@onready var nombre_slot_panel: Panel = $Slots/NombreSlotPanel
@onready var slot_domicilio_label: RichTextLabel = $Slots/DomicilioSlotPanel/DomicilioSlotLabel
@onready var domicilio_slot_panel: Panel = $Slots/DomicilioSlotPanel
@onready var slot_condicion_label: RichTextLabel = $Slots/CondicionSlotPanel/CondicionSlotLabel
@onready var condicion_slot_panel: Panel = $Slots/CondicionSlotPanel
@onready var marker_1: Marker2D = $Marker1
@onready var marker_2: Marker2D = $Marker2
@onready var marker_3: Marker2D = $Marker3
@onready var marker_4: Marker2D = $Marker4
@onready var marker_5: Marker2D = $Marker5
@onready var marker_6: Marker2D = $Marker6
@onready var marker_7: Marker2D = $Marker7
@onready var marker_8: Marker2D = $Marker8


@onready var sonido: AudioStreamPlayer2D = $Sonido
var sfx = ["res://SFX/Escritura_1.wav", "res://SFX/Escritura_2.wav", "res://SFX/Escritura_3.wav", "res://SFX/Escritura_4.wav"]



var drag_correcto_cuit_label: RichTextLabel = null
var drag_incorrecto_cuit_label: RichTextLabel = null
var drag_correcto_nombre_label: RichTextLabel = null
var drag_incorrecto_nombre_label: RichTextLabel = null
var drag_correcto_domicilio_label: RichTextLabel = null
var drag_incorrecto_domicilio_label: RichTextLabel = null
var drag_correcto_condicion_label: RichTextLabel = null
var drag_incorrecto_condicion_label: RichTextLabel = null
var factura_a = preload("res://Assets/Facturas/FACTURA A.png")
var factura_b = preload("res://Assets/Facturas/FACTURA B.png")

var seleccion_factura = ""
var cliente_factura = ""
var current_cuit_in_slot = ""

func _ready() -> void:
	mostrarInterfazDeRegistroDeFactura()
	await get_tree().process_frame
	guardarEnVariablesTodosLosDragsCorrectosEIncorrectos()	
	boton_continuar.pressed.connect(_on_boton_continuar_pressed)

func _on_boton_continuar_pressed() -> void:
	if slot_nombre_label.text == personaje.nombre_cliente and cuit_slot_panel.current_label == personaje.cuit_cliente and domicilio_slot_panel.current_label == personaje.domicilio_cliente and condicion_slot_panel.current_label == personaje.condicion_cliente and seleccion_factura == cliente_factura:
		comunicarAciertoDeRegistroDeFactura()
		return
	elif cuit_slot_panel.current_label == "" or slot_nombre_label.text == "" or slot_domicilio_label.text == "" or slot_condicion_label.text == "":
		esconderTodosLosDrags()
		comunicarFaltaDeDatosDeRegistroDeFactura()
	else:
		comunicarErrorDeRegistroDeFactura()
	resetearTodosLosSlots()

func comunicarErrorDeRegistroDeFactura():
	if slot_nombre_label.text != personaje.nombre_cliente:
		personaje.caja_dialogo.text = "¡Ese no es mi nombre!"
	if cuit_slot_panel.current_label != personaje.cuit_cliente:
		personaje.caja_dialogo.text = "¡Ese no es mi CUIT!"
	if domicilio_slot_panel.current_label != personaje.domicilio_cliente:
		personaje.caja_dialogo.text = "¡Ese no es mi domicilio!"
	if condicion_slot_panel.current_label != personaje.condicion_cliente:
		personaje.caja_dialogo.text = "¡Esa no es mi condicion!"
	if seleccion_factura != cliente_factura:
		personaje.caja_dialogo.text = "¡No pedí ese modelo de factura!"
	personaje.mood_cliente = "Enojado"
	personaje.cambiarEstadoDeCliente(personaje.mood_cliente)
	main.perderVida()

func comunicarAciertoDeRegistroDeFactura():
	personaje.caja_dialogo.text = ("¡Muchas gracias!")
	personaje.mood_cliente = "Feliz"
	personaje.cambiarEstadoDeCliente(personaje.mood_cliente)
	main.on_correcto()

func comunicarFaltaDeDatosDeRegistroDeFactura():
	personaje.caja_dialogo.text = ("Esto está incompleto...")
	personaje.mood_cliente = "Confuso"
	personaje.cambiarEstadoDeCliente(personaje.mood_cliente)
	main.perderVida()

func guardarEnVariablesTodosLosDragsCorrectosEIncorrectos():
	guardarEnVariablesDragsCorrectosEIncorrectosDeNombre()
	guardarEnVariablesDragsCorrectosEIncorrectosDeCUIT()
	guardarEnVariablesDragsCorrectosEIncorrectosDeDomicilio()
	guardarEnVariablesDragsCorrectosEIncorrectosDeCondicion()

func guardarEnVariablesDragsCorrectosEIncorrectosDeNombre():
	drag_correcto_nombre_label = get_node_or_null("Drags/NombreDragLabel")
	drag_incorrecto_nombre_label = get_node_or_null("Drags/NombreDragLabel2")
	
func guardarEnVariablesDragsCorrectosEIncorrectosDeCUIT():
	drag_correcto_cuit_label = get_node_or_null("Drags/CuitDragLabel")
	drag_incorrecto_cuit_label = get_node_or_null("Drags/CuitDragLabel2")
	
func guardarEnVariablesDragsCorrectosEIncorrectosDeDomicilio():
	drag_correcto_domicilio_label = get_node_or_null("Drags/DomicilioDragLabel")
	drag_incorrecto_domicilio_label = get_node_or_null("Drags/DomicilioDragLabel2")

func guardarEnVariablesDragsCorrectosEIncorrectosDeCondicion():
	drag_correcto_condicion_label = get_node_or_null("Drags/CondicionDragLabel")
	drag_incorrecto_condicion_label = get_node_or_null("Drags/CondicionDragLabel2")
	
func mostrarInterfazDeRegistroDeFactura():
	visible = false

# Mostrar factura y drags
func mostrarDatosDeFacturaSeleccionada(opcion: String) -> void:
	visible = true
	factura_sprite.visible = true
	match opcion:
		"A":
			factura_sprite.texture = factura_a
			seleccion_factura = "A"
		"B":
			factura_sprite.texture = factura_b
			seleccion_factura = "B"


	mostrarDragsDeNombre()
	mostrarDragsDeCUIT()
	mostrarDragsDeDomicilio()
	mostrarDragsDeCondicion()
	
func esconderDatosDeFactura() -> void:
	factura_sprite.visible = false
	esconderTodosLosDrags()
	resetearTodosLosSlots()

# Actualizar información del drag correcto
func actualizarInformacionDeCliente(cuit_cliente: String) -> void:
	if drag_correcto_cuit_label == null:
		drag_correcto_cuit_label = get_node_or_null("Drags/CuitDragLabel")
	if drag_correcto_cuit_label != null:
		drag_correcto_cuit_label.actualizar_label(cuit_cliente)
	else:
		push_error("drag_correcto_label es null al llamar actualizar_informacion")

# Posicionar aleatoriamente y mostrar Drags correctos e incorrectos  de datos de facturas
func mostrarDragsDeCUIT() -> void:
	if drag_correcto_cuit_label == null or drag_incorrecto_cuit_label == null:
		return
	drag_correcto_cuit_label.actualizar_label(personaje.cuit_cliente)
	drag_correcto_cuit_label.visible = true
	var cuit_falso = personaje.cuit_secundario
	drag_incorrecto_cuit_label.actualizar_label(cuit_falso)
	drag_incorrecto_cuit_label.visible = true
	posicionarAleatoriamenteDragsCUIT()
	
func mostrarDragsDeNombre() -> void:
	if drag_correcto_nombre_label == null or drag_incorrecto_nombre_label == null:
		return
	drag_correcto_nombre_label.text = personaje.nombre_cliente
	drag_correcto_nombre_label.visible = true
	var nombre_secundario = personaje.nombre_secundario
	drag_incorrecto_nombre_label.actualizar_label(nombre_secundario)
	drag_incorrecto_nombre_label.visible = true
	posicionarAleatoriamenteDragsNombre()

func mostrarDragsDeDomicilio() -> void:
	if drag_correcto_domicilio_label == null or drag_incorrecto_domicilio_label == null:
		return
	drag_correcto_domicilio_label.text = personaje.domicilio_cliente
	drag_correcto_domicilio_label.visible = true
	var domicilio_secundario = personaje.domicilio_secundario
	drag_incorrecto_domicilio_label.actualizar_label(domicilio_secundario)
	drag_incorrecto_domicilio_label.visible = true
	posicionarAleatoriamenteDragsDomicilio()

func mostrarDragsDeCondicion() -> void:
	if drag_correcto_condicion_label == null or drag_incorrecto_condicion_label == null:
		return
	drag_correcto_condicion_label.text = personaje.condicion_cliente
	drag_correcto_condicion_label.visible = true
	var condicion_secundario = personaje.condicion_secundario
	drag_incorrecto_condicion_label.actualizar_label(condicion_secundario)
	drag_incorrecto_condicion_label.visible = true
	posicionarAleatoriamenteDragsCondicion()

func posicionarAleatoriamenteDragsNombre() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_nombre_label.position = marker_1.position
			drag_incorrecto_nombre_label.position = marker_2.position
		2:
			drag_incorrecto_nombre_label.position = marker_1.position
			drag_correcto_nombre_label.position = marker_2.position

func posicionarAleatoriamenteDragsCUIT() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_cuit_label.position = marker_3.position
			drag_incorrecto_cuit_label.position = marker_4.position
		2:
			drag_incorrecto_cuit_label.position = marker_3.position
			drag_correcto_cuit_label.position = marker_4.position
			
func posicionarAleatoriamenteDragsDomicilio() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_domicilio_label.position = marker_5.position
			drag_incorrecto_domicilio_label.position = marker_6.position
		2:
			drag_incorrecto_domicilio_label.position = marker_5.position
			drag_correcto_domicilio_label.position = marker_6.position

func posicionarAleatoriamenteDragsCondicion() -> void:
	match randi_range(1,2):
		1:
			drag_correcto_condicion_label.position = marker_7.position
			drag_incorrecto_condicion_label.position = marker_8.position
		2:
			drag_incorrecto_condicion_label.position = marker_8.position
			drag_correcto_condicion_label.position = marker_7.position

# Esconder drags de datos
func esconderTodosLosDrags() -> void:
	visible = false
	esconderDragsDeNombre()
	esconderDragsDeCUIT()
	esconderDragsDeDomicilio()
	esconderDragsDeCondicion()
	
func esconderDragsDeNombre():
	if drag_correcto_nombre_label != null:
		drag_correcto_nombre_label.visible = false
	if drag_incorrecto_nombre_label != null:
		drag_incorrecto_nombre_label.visible = false
		
func esconderDragsDeCUIT():
	if drag_correcto_cuit_label != null:
		drag_correcto_cuit_label.visible = false
	if drag_incorrecto_cuit_label != null:
		drag_incorrecto_cuit_label.visible = false
		
func esconderDragsDeDomicilio():
	if drag_correcto_domicilio_label != null:
		drag_correcto_domicilio_label.visible = false
	if drag_incorrecto_domicilio_label != null:
		drag_incorrecto_domicilio_label.visible = false

func esconderDragsDeCondicion():
	if drag_correcto_condicion_label != null:
		drag_correcto_condicion_label.visible = false
	if drag_incorrecto_condicion_label != null:
		drag_incorrecto_condicion_label.visible = false

# Reseteo de slots de datos de factura
func resetearTodosLosSlots() -> void:
	resetearSlotDeNombre()
	resetearSlotDeCUIT()
	resetearSlotDeDomicilio()
	resetearSlotDeCondicion()

func resetearSlotDeNombre():
	if slot_cuit_label != null:
		slot_cuit_label.text = ""
	else:
		push_error("SlotCuitLabel no encontrado para resetear")

func resetearSlotDeCUIT():
	if slot_nombre_label != null:
		slot_nombre_label.text = ""
	else:
		push_error("SlotNombreLabel no encontrado para resetear")

func resetearSlotDeDomicilio():
	if slot_domicilio_label != null:
		slot_domicilio_label.text = ""
	else:
		push_error("SlotDomicilioLabel no encontrado para resetear")

func resetearSlotDeCondicion():
	if slot_condicion_label != null:
		slot_condicion_label.text = ""
	else:
		push_error("SlotCondicionLabel no encontrado para resetear")


func reproducirSonido():
	sonido.stream = load(sfx[randi_range(0, sfx.size()-1)])
	sonido.play()
