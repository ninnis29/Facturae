# Este componente se encarga de detectar que el juego se puso en pantalla completa

class_name FullscreenManagerComponent

extends Node

var fullscreenOn = true

func _process(_delta):
	if Input.is_action_just_pressed("Fullscreen"):
		fullscreenOn = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if not fullscreenOn:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreenOn = true
		elif fullscreenOn:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().size = Vector2(1152, 648)
			get_window().position = DisplayServer.screen_get_size()/2 - get_window().size/2
			fullscreenOn = false
