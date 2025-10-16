extends Node2D
@onready var musica: AudioStreamPlayer2D = $musica

func reproducirMusica():
	musica.play()

func frenarMusica():
	musica.stop()
