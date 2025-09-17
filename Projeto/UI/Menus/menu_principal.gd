extends Node2D

var jogo_salvo : SaveFile

@onready var continuar: Button = $CenterContainer/BotoesPrincipais/continuar


func _ready() -> void:
	get_tree().paused = false
	ControleDeAudio.toca_musica("menu", false)
	var arquivos_salvamento = SaveService.GetSlots()
	continuar.disabled = true
	jogo_salvo = null
	if len(arquivos_salvamento) > 0:
		jogo_salvo = arquivos_salvamento[0]
		continuar.disabled = false

#ao clicar em jogar deveria ir direto para a tela de cenas iniciais do jogo.
func _on_jogar_pressed() -> void:
	SaveService.DeleteSlot(Constantes.ID_SALVAR)
	SaveService.NewSlot(Constantes.ID_SALVAR)
	SaveService.LoadGame(Constantes.ID_SALVAR)
	get_tree().change_scene_to_file(Globais.niveis[0].local)

#ao clicar vai para a tela de opções do jogo
func _on_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/tela_opcoes.tscn")

#ao clicar vai para a tela com a imagem da cartilha e informações para baixá-la
func _on_cartilha_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/tela_cartilha_aaas.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_continuar_pressed() -> void:
	SaveService.LoadGame(Constantes.ID_SALVAR)
	get_tree().change_scene_to_file(EstadoDeJogo.cena_atual)
