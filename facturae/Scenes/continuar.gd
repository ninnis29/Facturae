extends Button

@onready var fondo = $Sprite2D  # El Sprite hijo con el botón completo
var textura_normal: Texture2D
var textura_hover: Texture2D

func _ready():
	# Guardamos las texturas
	textura_normal = fondo.texture
	textura_hover = preload("res://Assets/EntregarHover.png")  # sprite más oscuro

	# Conectamos señales de hover
	self.mouse_entered.connect(_on_hover)
	self.mouse_exited.connect(_on_hover_exit)

func _on_hover():
	fondo.texture = textura_hover

func _on_hover_exit():
	fondo.texture = textura_normal

func _pressed():
	# Efecto de click usando await
	fondo.scale = Vector2(0.95, 0.95)
	await get_tree().create_timer(0.1).timeout
	fondo.scale = Vector2(1, 1)
