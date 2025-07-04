class_name Personagem
extends CharacterBody2D

@export var id: String
@export var nome: String
@export var referencia_de_colisao_para_dialogo: CollisionShape2D

var esta_dialogando := false

func encerrar_dialogo():
	esta_dialogando = false

func iniciar_dialogo(dialogo: DialogueResource, titulo: String, duracao := -1.0):
	esta_dialogando = true
	var balao: DialogueBalloon = preload("uid://2nh1i0xeu1tt").instantiate()
	get_tree().current_scene.add_child(balao)
	balao.start(dialogo, titulo)
	balao.tree_exited.connect(encerrar_dialogo)
	
	if duracao > 0:
		await get_tree().create_timer(duracao).timeout
		balao.remove()
