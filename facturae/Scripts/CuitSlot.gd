extends Panel

@onready var cuit_slot_label: RichTextLabel = $CuitSlotLabel

var current_label = ""

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	cuit_slot_label.text = str(data)
	current_label = str(data)
	await get_tree().create_timer(0.01).timeout
	self.size.x = cuit_slot_label.size.x + 20
