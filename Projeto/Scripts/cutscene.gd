extends Node

func executar_animacao(animacao: String) -> void:
	var animation_player := get_tree().current_scene.get_node("Geral") as AnimationPlayer
	animation_player.play(animacao)
	
func executar_animacao_elza(animacao: String) -> void:
	var animation_player_elza := get_tree().current_scene.get_node("Personagens/Elza/elza rig/AnimationPlayer") as AnimationPlayer
	animation_player_elza.play(animacao)

func executar_animacao_carolina(animacao: String) -> void:
	var animation_player_carolina := get_tree().current_scene.get_node("Personagens/Carolina/carolina_rig/AnimationPlayer") as AnimationPlayer
	animation_player_carolina.play(animacao)
