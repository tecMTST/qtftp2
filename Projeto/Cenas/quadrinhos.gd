extends Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var quadrinho_atual : int = 1

func _ready() -> void:
	animation_player.play("bounce_quadrinhos_1")

func _on_avancar_pressed() -> void:
	if quadrinho_atual == 1:
		animation_player.play("bounce_quadrinhos_2")
		quadrinho_atual += 1
	elif quadrinho_atual == 2:
		animation_player.play("bounce_quadrinhos_3")
		quadrinho_atual += 1
