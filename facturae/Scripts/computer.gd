extends Node2D
#@onready var continuar_btn = $Continuar
signal facturaA
signal facturaB
signal facturaC
signal continuar

#var seleccion_jugador: String = "" 

func _on_factura_a_pressed() -> void:
	emit_signal("facturaA")
	pass 

func _on_factura_b_pressed() -> void:
	emit_signal("facturaB")
	pass 

func _on_factura_c_pressed() -> void:
	emit_signal("facturaC")
	pass 

func _on_button_pressed() -> void:
	emit_signal("continuar")
	pass 
	
