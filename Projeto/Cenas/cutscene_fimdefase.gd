extends Node2D

@export var timeline : DialogicTimeline

func _ready() -> void:
	var layout = Dialogic.start(timeline)
	if layout.has_method("register_character"):
		var personagens := get_tree().get_nodes_in_group("personagem")
		for personagem in personagens as Array[Personagem]:
			layout.register_character(personagem.id, personagem)
	Dialogic.signal_event.connect(evento_dialogic)

func evento_dialogic(acao : String):
	var quem = acao.split(":")[0]
	var onde = acao.split(":")[1]
