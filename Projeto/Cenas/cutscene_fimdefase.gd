extends Node2D

@export var proxima_fase : String = ""
@export var timeline : DialogicTimeline
@onready var transicao_cena: TransicaoCena = $TransicaoCena

func _ready() -> void:
	var layout = Dialogic.start(timeline)
	if layout.has_method("register_character"):
		var personagens := get_tree().get_nodes_in_group("personagem")
		for personagem in personagens as Array[Personagem]:
			layout.register_character(personagem.id, personagem)

func proxima_cena(cena : String = proxima_fase):
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	get_tree().change_scene_to_file(cena)

func _on_botao_temporizado_acionado() -> void:
	Dialogic.end_timeline()
	proxima_cena()
