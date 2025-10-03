extends Node2D

@export var proxima_fase : String = ""
@export var timeline : DialogicTimeline
@export var sprites_para_deletar: Array[Sprite2D]  # Add sprites to delete here
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

func deletar_sprites():
	for sprite in sprites_para_deletar:
		if sprite and is_instance_valid(sprite):
			sprite.queue_free()
	sprites_para_deletar.clear()

func _on_botao_temporizado_acionado() -> void:
	Dialogic.end_timeline()
	proxima_cena()
