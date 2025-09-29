extends Node

func trocar_rosto(id : String, rosto : String):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.mudar_rosto(rosto)

func mover_para(id : String, waypoint : String):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.mover_para(waypoint)

func olhar_para(id : String, direcao : String):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.olhar_para(direcao)

func ordem(id : String, index : int):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.ordem(index)

func executar_animacao(id : String, animacao : String):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.animacao(animacao)
	
func executar_funcao(id : String, funcao : String):
	var personagem = get_tree().get_nodes_in_group("personagem").filter(
		func(p : Personagem): return p.id == id
	)[0] as Personagem
	personagem.call(funcao)

func finalizar_cena(cena : String):
	var cena_atual = get_tree().current_scene	
	if cena_atual.is_in_group("cutscene") :
		cena_atual.proxima_cena(cena)
