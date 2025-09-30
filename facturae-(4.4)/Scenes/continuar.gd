extends TextureButton

var textura_normal: Texture2D
var textura_hover: Texture2D



func _pressed():
	# Efecto de click usando await
	scale = Vector2(0.95, 0.95)
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(1, 1)
