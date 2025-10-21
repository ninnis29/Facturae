extends Node2D
@onready var caja_dialogo = $Label
@onready var facturas = $"../Facturas"
@onready var computer = $"../computer"
@onready var sprite: Sprite2D = $ClienteSprite
@onready var animacion : AnimationPlayer = $ClienteAnimacion

func _ready() -> void:
	generarFacturaDeCliente()
	animacion.play("Aparicion")

var dialogos = {
	"A": ["Podria darme la factura A?", "Deme factura A"],
	"B": ["Factura B, por favor.", "Buenos dias, factura B?"],
	"C": ["Hola! Factura C!", "Qué tal? Factura C?"]
}

var lista_nombres = [ # LISTA DE POSIBLES NOMBRES
	"Juan", "Pablo", "Nahuel", "Gabriel", "Agustin", "Enrique", 
	"Facundo", "Osvaldo", "Pedro", "Carlos"]

var lista_nombres_femeninos = [ # NOMBRES FEMENINOS
	"Morena", "Yune", "Ana", "Maria", "Lucia", "Carolina", "Julieta", "Laura",
	"Camila", "Sofia", "Gabriela", "Rocío"
]

var lista_apellidos = [ # LISTA DE POSIBLES APELLIDOS
	"Martinez", "Lezcano", "Ponce", "Lugano", "Fiorotto", "Richards",
	"Schlot", "Leal", "Smith", "Lenton", "Bielli", "Monje"]

var lista_cuits = [ # LISTA DE POSIBLES CUITS
	"27-45219605-3",
	"24-32669883-2",
	"27-45604058-1",
	"23-37525112-4",
	"24-41286049-3",
	"20-43520500-4",
	"24-38753984-7",
	"20-46412621-0",
	"23-38774990-0",
	"20-32736610-7"]

var lista_domicilio_calle = [ # LISTA DE POSIBLES CALLES
	"Libertad",
	"Talcahuano",
	"Ricardo Gutierrez",
	"Av. Pelliza",
	"Belgrano",
	"Julio Sosa",
	"Luis Miguel",
	"9 de Julio"]

var lista_domicilio_altura = [ # LISTA DE POSIBLES ALTURAS
	"1441",
	"514",
	"314",
	"6381",
	"1914",
	"2005",
	"401",
	"15",
	"58"]

var lista_condiciones_iva = [ # LISTA DE POSIBLES CONDICIONES IVA
	"Responsable Inscripto",
	"No Responsable",
	"Exento",
	"Monotributo",
	"Consumidor Final"]

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

func generarFacturaDeCliente() -> void:
	var opciones = ["A", "B", "C"]
	opcion_actual = opciones.pick_random()
	var linea_dialogo = dialogos[opcion_actual].pick_random()
	caja_dialogo.text = linea_dialogo
	facturas.cliente_factura = opcion_actual
	generacionDeDatosDeCliente()

func generarNuevoCliente() -> void:
	generarFacturaDeCliente()
	animacion.play("Aparicion")

## GENERACION DE TODOS LOS DATOS DE UNA. Invocado a la hora de crear una nueva peticion (factura_random() )
func generacionDeDatosDeCliente() -> void:
	generarDatosPrimariosAleatorios()
	generarDatosSecundariosAleatorios()
	actualizarEstadoDeCliente()
	cambiarEstadoDeCliente("Normal")
	await get_tree().process_frame
	facturas.actualizarInformacionDeCliente(cuit_cliente)
	computer.mostrarDatosDeCliente(
		nombre_cliente,
		apellido_cliente,
		cuit_cliente,
		domicilio_cliente,
		condicion_cliente
	)


func generarNombreCompletoAleatorio() -> void:
	# Elegir género
	genero_cliente = ["hombre", "mujer"].pick_random()
	
	if genero_cliente == "hombre":
		nombre_cliente = lista_nombres.pick_random()
	else:
		nombre_cliente = lista_nombres_femeninos.pick_random()
		
	apellido_cliente = lista_apellidos.pick_random()
	
	### Debug
	#print("------ Nombre Completo ------")
	#print(nombre_cliente)
	#print(apellido_cliente)

func generarCUITAleatorio() -> void: # Genera CUIT
	cuit_cliente = lista_cuits.pick_random()
	
	### Debug
	#print("------ CUIT ------")
	#print(cuit_cliente)

func generarDomicilioAleatorio() -> void: # Genera Domicilio agrupando Calle + Altura
	domicilio_cliente = lista_domicilio_calle.pick_random() + " " + lista_domicilio_altura.pick_random()
	
	### Debug
	#print("------ DIRECCION ------")
	#print(domicilio_cliente)

func generarCondicionIVAAleatorio() -> void:
	condicion_cliente = lista_condiciones_iva.pick_random()
	
	### Debug
	#print("------ CONDICION ------")
	#print(condicion_cliente)

func generarDatosPrimariosAleatorios() -> void:
	generarNombreCompletoAleatorio()
	generarCUITAleatorio()
	generarDomicilioAleatorio()
	generarCondicionIVAAleatorio()
	
func generarDatosSecundariosAleatorios() -> void:
	generarNombreCompletoSecundarioAleatorio()
	generarCuitSecundarioAleatorio()
	generarDomicilioSecundarioAleatorio()
	generarCondicionIVASecundarioAleatorio()
	

func generarNombreCompletoSecundarioAleatorio() -> void:
	nombre_secundario = nombre_cliente
	while nombre_secundario == nombre_cliente:
		if genero_cliente == "hombre":
			nombre_cliente = lista_nombres.pick_random()
		else:
			nombre_cliente = lista_nombres_femeninos.pick_random()

func generarCuitSecundarioAleatorio() -> void:
	cuit_secundario = cuit_cliente
	while cuit_secundario == cuit_cliente:
		cuit_secundario = lista_cuits.pick_random()
	
func generarDomicilioSecundarioAleatorio() -> void:
	domicilio_secundario = domicilio_cliente
	while domicilio_secundario == domicilio_cliente:
		domicilio_secundario = lista_domicilio_calle.pick_random() + " " + lista_domicilio_altura.pick_random()
	
func generarCondicionIVASecundarioAleatorio() -> void:
	condicion_secundario = condicion_cliente
	while condicion_secundario == condicion_cliente:
		condicion_secundario = lista_condiciones_iva.pick_random()
	
func cambiarEstadoDeCliente(nuevo_mood: String) -> void:
	mood_cliente = nuevo_mood
	actualizarEstadoDeCliente()
		
func actualizarEstadoDeCliente() -> void:
	var ruta = ""
	if genero_cliente == "hombre":
		ruta = "res://Assets/Personajes/Empresario/Empresario - %s.png" % mood_cliente
	else:
		ruta = "res://Assets/Personajes/Minita/Minita - %s.png" % mood_cliente
	
	sprite.texture = load(ruta)
