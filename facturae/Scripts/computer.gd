extends Node2D

signal facturaA
signal facturaB
signal facturaC
signal continuar
signal retroceder

# --- NODOS ---
@onready var panel_seleccion = $PanelSeleccion
@onready var panel_cliente = $PanelCliente

@onready var nombre_label = get_node_or_null("PanelCliente/NombreLabel")
@onready var cuit_label = get_node_or_null("PanelCliente/CuitLabel")
@onready var domicilio_label = get_node_or_null("PanelCliente/DomicilioLabel")
@onready var condicion_label = get_node_or_null("PanelCliente/CondicionLabel")


@onready var boton_continuar = $Continuar
@onready var boton_retroceder = $Retroceder

# --- READY ---
func _ready() -> void:
	# Mostrar inicialmente solo panel de selección
	panel_seleccion.visible = true
	panel_cliente.visible = false
	boton_retroceder.visible = false
	limpiarDatosDeFactura()

	# Conectar señales de botones
	boton_continuar.pressed.connect(self._on_continuar_pressed)
	boton_retroceder.pressed.connect(self._on_retroceder_pressed)

# --- BOTONES PANEL SELECCIÓN ---
func _on_factura_a_pressed() -> void:
	emit_signal("facturaA")
	habilitarBotonesDeInteraccion()

func _on_factura_b_pressed() -> void:
	emit_signal("facturaB")
	habilitarBotonesDeInteraccion()

func _on_factura_c_pressed() -> void:
	emit_signal("facturaC")
	habilitarBotonesDeInteraccion()

func _on_continuar_pressed() -> void:
	emit_signal("continuar")
	# Mostrar nuevamente las opciones para la siguiente factura
	panel_seleccion.visible = true
	panel_cliente.visible = false

# --- BOTON RETROCEDER ---
func _on_retroceder_pressed() -> void:
	panel_cliente.visible = false
	panel_seleccion.visible = true
	boton_retroceder.visible = false
	# Llamamos a Facturas para resetear su UI
	var facturas_node = get_node("/root/Main/Facturas")
	facturas_node.esconderDatosDeFactura()        # Oculta la factura y resetea drags/slots
	emit_signal("retroceder")

# --- FUNCION AUXILIAR ---
func habilitarBotonesDeInteraccion() -> void:
	panel_seleccion.visible = false
	panel_cliente.visible = true
	boton_retroceder.visible = true

# --- MOSTRAR DATOS DEL CLIENTE ---
# Esta función será llamada desde personaje.gd
func mostrarDatosDeCliente(nombre: String, apellido: String, cuit: String, domicilio: String, condicion: String) -> void:
	if nombre_label != null:
		nombre_label.text = "Nombre: %s %s" % [nombre, apellido]
	if cuit_label != null:
		cuit_label.text = "CUIT: %s" % cuit
	if domicilio_label != null:
		domicilio_label.text = "Domicilio: %s" % domicilio
	if condicion_label != null:
		condicion_label.text = "Condición IVA: %s" % condicion

func limpiarDatosDeFactura() -> void:
	nombre_label.text = "Nombre: "
	cuit_label.text = "CUIT: "
	domicilio_label.text = "Domicilio: "
	condicion_label.text = "Condición IVA: "
