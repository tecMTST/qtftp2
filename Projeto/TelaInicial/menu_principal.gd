extends Node2D

func _ready() -> void:
	get_tree().paused = false
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")

#ao clicar em jogar deveria ir direto para a tela de cenas iniciais do jogo.
func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/cutscene_quadrinhos.tscn")

#ao clicar vai para a tela de opções do jogo
func _on_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/tela_opcoes.tscn")

#ao clicar vai para a tela com a imagem da cartilha e informações para baixá-la
func _on_cartilha_pressed() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/tela_cartilha_aaas.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()
