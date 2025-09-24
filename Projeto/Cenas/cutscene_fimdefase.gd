extends Node2D

func _ready() -> void:
	var layout = Dialogic.start("res://timeline_cutscene_fimdefase_tutorial.dtl")	
	if layout.has_method("register_character"):
		var personagens := get_tree().get_nodes_in_group("personagem")
		for personagem in personagens as Array[Personagem]:
			layout.register_character(personagem.id, personagem)
	
	var animation_player_carolina := get_tree().current_scene.get_node("Personagens/Carolina/carolina_rig/AnimationPlayer") as AnimationPlayer
	animation_player_carolina.play("qtftd anims/sentar_carolina_celular")
