extends Node2D

var jogo_salvo : SaveFile
var fundo = self_modulate

@onready var continuar: Button = $CenterContainer/BotoesPrincipais/continuar
@onready var transicao_cena: TransicaoCena = $TransicaoCena


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
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	EstadoDeJogo.nivel_atual = 1
	get_tree().change_scene_to_file(Globais.niveis[0].local)

#ao clicar vai para a tela com a imagem da cartilha e informações para baixá-la
func _on_cartilha_pressed() -> void:
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	get_tree().change_scene_to_file("res://UI/Menus/tela_cartilha_aaas.tscn")

func _on_sair_pressed() -> void:
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	get_tree().quit()

#ao clicar vai para a tela com a imagem da cartilha e informações para baixá-la
func _on_extras_pressed() -> void:
	fundo.a = 0.5
	self_modulate = fundo
	get_tree().change_scene_to_file("res://UI/Menus/menu_extras.tscn")

func _on_continuar_pressed() -> void:
	SaveService.LoadGame(Constantes.ID_SALVAR)
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	get_tree().change_scene_to_file(EstadoDeJogo.cena_atual)
