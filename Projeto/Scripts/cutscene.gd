extends Node

func executar_animacao(animacao: String) -> void:
	var animation_player := get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer
	animation_player.play(animacao)
