extends Node2D
@onready var caja_dialogo = $Label
@onready var facturas = $"../Facturas"
@onready var computer = $"../computer"
@onready var sprite: Sprite2D = $ClienteSprite
@onready var animacion : AnimationPlayer = $ClienteAnimacion


var nombre_cliente = ""
var apellido_cliente = ""
var cuit_cliente = ""
var domicilio_cliente = ""
var condicion_cliente = ""
var cuit_secundario = ""
var nombre_secundario = ""
var domicilio_secundario = ""
var condicion_secundario = ""

var opcion_actual = ""
var genero_cliente = ""
var mood_cliente = "Normal"

func _ready() -> void:
	generarNuevoCliente()

func generarFacturaDeCliente() -> void:
	
	match randi_range(0, 2):
		0: opcion_actual = "Empresario"
		1: opcion_actual = "Kiosquera"
		2: opcion_actual = "Bombero"

	
	var linea_dialogo = Dialogos[opcion_actual]
	caja_dialogo.text = linea_dialogo
	facturas.cliente_factura = Personajes[opcion_actual]["factura"]
	print(facturas.cliente_factura)
	generacionDeDatosDeCliente()

func generarNuevoCliente() -> void:
	generarFacturaDeCliente()
	animacion.play("Aparicion")

## GENERACION DE TODOS LOS DATOS DE UNA. Invocado a la hora de crear una nueva peticion (factura_random() )
func generacionDeDatosDeCliente() -> void:
	generarDatosPrimarios()
	generarDatosSecundarios()
	actualizarEstadoDeCliente()
	cambiarEstadoDeCliente("Normal")
	await get_tree().process_frame
	facturas.actualizarInformacionDeCliente(cuit_cliente)
	computer.mostrarTodosLosDatosDeCliente(
		nombre_cliente,
		apellido_cliente,
		cuit_cliente,
		domicilio_cliente,
		condicion_cliente
	)

func generarDatosPrimarios() -> void:
	nombre_cliente = Personajes[opcion_actual]["nombre"]
	cuit_cliente = Personajes[opcion_actual]["cuit"]
	domicilio_cliente = Personajes[opcion_actual]["domicilio"]
	condicion_cliente = Personajes[opcion_actual]["condicion"]

func generarDatosSecundarios() -> void:
	nombre_secundario = Personajes[opcion_actual]["nombres_secundarios"][randi_range(0,2)]
	cuit_secundario = Personajes[opcion_actual]["cuit_secundarios"][randi_range(0,2)]
	domicilio_secundario = Personajes[opcion_actual]["domicilio_secundarios"][randi_range(0,2)]
	condicion_secundario = Personajes[opcion_actual]["condicion_secundarios"][randi_range(0,2)]




func cambiarEstadoDeCliente(nuevo_mood: String) -> void:
	mood_cliente = nuevo_mood
	actualizarEstadoDeCliente()

func actualizarEstadoDeCliente() -> void:
	var ruta = ""
	match opcion_actual:
		"Empresario":
			ruta = "res://Assets/Personajes/Empresario/Empresario - %s.png" % mood_cliente
		"Kiosquera":
			ruta = "res://Assets/Personajes/Minita/Minita - %s.png" % mood_cliente
		"Bombero":
			ruta = "res://Assets/Personajes/Bombero/Bombero - %s.png" % mood_cliente
	
	sprite.texture = load(ruta)

## ###############################################################################
## //////////////////////////////             \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
## ///////////////////////////// NUEVA SECCION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
## \\\\\\\\\\\\\\\\\\\\\\\\\\\\\   PERSONAJES  ///////////////////////////////////
## \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\             ////////////////////////////////////
## ###############################################################################


var Personajes: Dictionary = {
	"Empresario" : {
		"nombre" : "Soluciones Pakpak",
		"cuit" : "30-99664348-1",
		"domicilio" : "Av. Maipú 416",
		"condicion" : "Responsable Inscripto",
		"factura" : "A",
		"nombres_secundarios" : ["Soluciones Pokpok", "Solucion Final", "Soluto Solvente"],
		"cuit_secundarios" : ["30-66994843-1", "31-99664348-1", "30-99968384-1"],
		"domicilio_secundarios" : ["Av. Maipú 179", "Av. Paimú 416", "Av. Maipú 614"],
		"condicion_secundarios" : ["Irresponsable Inscripto", "Inscripto Responsable", "Exento"]
	},
	
	"Kiosquera" : {
		"nombre" : "Lorena Gutierrez",
		"cuit" : "24-77123456-3",
		"domicilio" : "Alsina 783",
		"condicion" : "Monotributista",
		"factura" : "B",
		"nombres_secundarios" : ["Laura Gutierrez", "Laurel Gutierrez", "Lorena Martinez"],
		"cuit_secundarios" : ["24-11723455-3", "25-77123456-3", "24-12345677-3"],
		"domicilio_secundarios" : ["Alseno 783", "Alfonsín 783", "Alsina 387"],
		"condicion_secundarios" : ["Monotributo", "Monotribunal", "Responsable Inscripto"]
	},
	
	"Emprendedora" : {
		"nombre" : "Julieta Schlott",
		"cuit" : "27-45698712-2",
		"domicilio" : "Pringles 1984",
		"condicion" : "Monotributista",
		"factura" : "C",
		"nombres_secundarios" : ["Julian Schlott", "Julieta Shot", "Jimena Schlott"],
		"cuit_secundarios" : ["27-65478921-2", "28-45698712-2", "27-98745612-2"],
		"domicilio_secundarios" : ["Pringles 1812", "Ringo 1984", "Pringles 4891"],
		"condicion_secundarios" : ["Monotributo", "Monotribunal", "Tributista"]
	},
	
	"Bombero" : {
		"nombre" : "Asociación Cuartel Voluntario",
		"cuit" : "33-33445566-4",
		"domicilio" : "Av. Avellaneda 1535",
		"condicion" : "Exento",
		"factura" : "B",
		"nombres_secundarios" : ["Asociación Cuartel Pago", "Asociación Carteles Voluntarios", "Asociación Cuarteto Denos"],
		"cuit_secundarios" : ["33-44336655-4", "34-33445566-4", "33-34345656-4"],
		"domicilio_secundarios" : ["Av. Avellanas 1535", "Avellaneda 1535", "Av. Llanave 5351"],
		"condicion_secundarios" : ["Excento", "Monotributista", "Responsable Inscripto"]
	}
}

## ###############################################################################
##  /////////////////////////////                 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
## /////////////////////////////   NUEVA SECCION   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
## \\\\\\\\\\\\\\\\\\\\\\\\\\\\\      DIALOGOS     ////////////////////////////////////
##  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\                 ////////////////////////////////////
## ###############################################################################

var Dialogos: Dictionary = {
	"Empresario" : "Hola, ¿cómo va? Soy empresario, nunca te ví por acá. Vine a buscar la factura para mi empresa que es responsable inscripta.",
	"Kiosquera" : "¡Hola! Sos el/la pasante nuev@, no? Soy la kiosquera del barrio, vengo por la factura de la compra… Soy monotributista.",
	"Bombero" : "Buenas, vengo de parte del cuartel. Siempre vengo acá y nunca te vi, debes ser nuev@. En fin, porfa dame IVA exento."
}
