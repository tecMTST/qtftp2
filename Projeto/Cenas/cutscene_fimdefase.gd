extends Node2D

@export var timeline : DialogicTimeline

func _ready() -> void:
	var layout = Dialogic.start(timeline)
	if layout.has_method("register_character"):
		var personagens := get_tree().get_nodes_in_group("personagem")
		for personagem in personagens as Array[Personagem]:
			layout.register_character(personagem.id, personagem)
