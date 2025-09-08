extends Node2D

@onready var factura_sprite = $Facturita

var factura_a = preload("res://Assets/Facturita_A.png")
var factura_b = preload("res://Assets/Facturita_B.png")
var factura_c = preload("res://Assets/Facturita_C.png")

func mostrar_factura(opcion):
	match opcion:
		"A":
			factura_sprite.texture = factura_a
		"B":
			factura_sprite.texture = factura_b
		"C":
			factura_sprite.texture = factura_c
