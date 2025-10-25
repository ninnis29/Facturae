extends RichTextLabel

func _get_drag_data(_at_position: Vector2) -> Variant:
	# Usar el texto actual del drag, no el NOMBRE del personaje
	var data = text

	var prev_label = RichTextLabel.new()
	prev_label.text = text
	prev_label.custom_minimum_size = Vector2(100, 100)
	prev_label.fit_content = true
	set_drag_preview(prev_label)
	
	return data

func actualizar_label(nombre: String) -> void:
	text = nombre
