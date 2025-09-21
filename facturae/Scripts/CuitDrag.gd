extends RichTextLabel

@onready var personaje: Node2D = $"../../../Personaje"


func _get_drag_data(at_position: Vector2) -> Variant:
	var data = personaje.cuit_cliente
	
	var prev_label = RichTextLabel.new()
	prev_label.text = text
	prev_label.custom_minimum_size = Vector2(100, 100)
	prev_label.fit_content = true
	set_drag_preview(prev_label)
	
	return data

func actualizar_label(cuit):
	text = cuit
