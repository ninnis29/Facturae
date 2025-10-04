extends Panel

@onready var domicilio_slot_label: RichTextLabel = $DomicilioSlotLabel

var current_label = ""

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	domicilio_slot_label.text = str(data)
	current_label = str(data)
