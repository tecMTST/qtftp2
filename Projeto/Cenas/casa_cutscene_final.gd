extends Node2D

@onready var player: Player = $Personagens/Player
@onready var filha: Filha = $Personagens/Filha

func _ready() -> void:
	var layout = Dialogic.start("res://Dialogo/teste.dtl")
	if layout.has_method("register_character"):
		var personagens := get_tree().get_nodes_in_group("personagem")
		for personagem in personagens as Array[Personagem]:
			layout.register_character(personagem.id, personagem)
	Dialogic.signal_event.connect(evento_dialogic)	

func evento_dialogic(acao : String):
	var quem = acao.split(":")[0]
	var onde = acao.split(":")[1]
	match quem:
		"carol":
			filha.mover_para_waypoint(onde)
		"elza":
			pass
