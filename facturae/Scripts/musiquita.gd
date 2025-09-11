extends Node2D
@onready var musica: AudioStreamPlayer2D = $musica

func reproducir_musica():
	musica.play()

func frenar_musica():
	musica.stop()
