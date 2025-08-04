extends Node2D

@onready var continuar: Button = $CenterContainer/BotoesPrincipais/continuar

var jogo_salvo : SaveFile

func _ready() -> void:
	get_tree().paused = false
	ControleDeAudio.toca_musica("menu", false)
	var arquivos_salvamento = SaveService.GetSlots()
	continuar.visible = false
	jogo_salvo = null
	if len(arquivos_salvamento) > 0:
		jogo_salvo = arquivos_salvamento[0]
		continuar.visible = true	

#ao clicar em jogar deveria ir direto para a tela de cenas iniciais do jogo.
func _on_jogar_pressed() -> void:
	SaveService.DeleteSlot(Constantes.ID_SALVAR)
	get_tree().change_scene_to_file("res://Cenas/cutscene_quadrinhos.tscn")

#ao clicar vai para a tela de opções do jogo
func _on_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/tela_opcoes.tscn")

#ao clicar vai para a tela com a imagem da cartilha e informações para baixá-la
func _on_cartilha_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/tela_cartilha_aaas.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_continuar_pressed() -> void:		
	SaveService.LoadGame(jogo_salvo.SlotId)
	get_tree().change_scene_to_file(jogo_salvo.CurrentSceneId)
