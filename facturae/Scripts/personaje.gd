extends Node2D
@onready var caja_dialogo = $Label
@onready var facturas = $"../Facturas"
@onready var computer = $"../computer"

func _ready() -> void:
	factura_random()

var dialogos = {
	"A": ["Podria darme la factura A?", "Deme factura A"],
	"B": ["Factura B, por favor.", "Buenos dias, factura B?"],
	"C": ["Hola! Factura C!", "Qué tal? Factura C?"]
}

var lista_nombres = [ # LISTA DE POSIBLES NOMBRES
	"Juan", "Pablo", "Nahuel", "Gabriel", "Agustin", "Enrique", 
	"Facundo", "Osvaldo", "Pedro", "Carlos"]

var lista_apellidos = [ # LISTA DE POSIBLES APELLIDOS
	"Martinez", "Lezcano", "Ponce", "Lugano", "Fiorotto", "Richards",
	"Schlot", "Leal", "Smith", "Lenton"]

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

var opcion_actual = ""

func factura_random() -> void:
	var opciones = ["A", "B", "C"]
	opcion_actual = opciones.pick_random()
	var linea_dialogo = dialogos[opcion_actual].pick_random()
	caja_dialogo.text = linea_dialogo
	
	generacion_datos_cliente()

func nueva_peticion() -> void:
	factura_random()


## GENERACION DE TODOS LOS DATOS DE UNA. Invocado a la hora de crear una nueva peticion (factura_random() )
func generacion_datos_cliente() -> void: 
	nombre_completo_random()
	cuit_random()
	domicilio_random()
	condicion_iva()
	await get_tree().process_frame
	facturas.actualizar_informacion(cuit_cliente)
	computer.mostrar_datos_cliente(
		nombre_cliente,
		apellido_cliente,
		cuit_cliente,
		domicilio_cliente,
		condicion_cliente
	)


func nombre_completo_random() -> void: # Genera nombre
	
	nombre_cliente = lista_nombres.pick_random()
	apellido_cliente = lista_apellidos.pick_random()
	
	### Debug
	#print("------ Nombre Completo ------")
	#print(nombre_cliente)
	#print(apellido_cliente)

func cuit_random() -> void: # Genera CUIT
	cuit_cliente = lista_cuits.pick_random()
	
	### Debug
	#print("------ CUIT ------")
	#print(cuit_cliente)

func domicilio_random() -> void: # Genera Domicilio agrupando Calle + Altura
	
	domicilio_cliente = lista_domicilio_calle.pick_random() + " " + lista_domicilio_altura.pick_random()
	
	### Debug
	#print("------ DIRECCION ------")
	#print(domicilio_cliente)

func condicion_iva() -> void:
	condicion_cliente = lista_condiciones_iva.pick_random()
	
	### Debug
	#print("------ CONDICION ------")
	#print(condicion_cliente)

func generar_cuit_secundario() -> String:
	var cuit_secundario = cuit_cliente
	while cuit_secundario == cuit_cliente:
		cuit_secundario = lista_cuits.pick_random()
	return cuit_secundario
