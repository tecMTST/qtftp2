class_name BaguncaCena
extends BaseInteragivel

@export var baguncas : Array[Texture2D] = []
@onready var sprite_2d: Sprite2D = $Sprite2D

func  _ready() -> void:
	nome = "bagunca"
	sprite_2d.texture = baguncas.pick_random()

func _on_componente_interagivel_interagir(_jogador):
	if(!_jogador.objeto_agarrado):
		_jogador.ajuntar()
		await get_tree().create_timer(0.5).timeout
		queue_free()
