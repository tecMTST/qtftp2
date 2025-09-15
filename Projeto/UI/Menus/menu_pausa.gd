class_name MenuPausa extends Control

signal continuar

@export var briefing : Briefing
@onready var fase: Label = $Fase
@onready var receita_atual: TextureRect = $"Receita Atual"
@onready var botao_briefing: Button = $"TextureRect/Menu Abas/botao_briefing"



func atualizar() -> void:
	fase.text=ControleDeFase.nivel_atual.nome
	botao_briefing.icon=load(ControleDeFase.receita_selecionada.caminho_sprite)
	

# essa função despausa o jogo
func _on_continuar_pressed() -> void:
	continuar.emit()
	get_tree().paused = false
	hide()


# sai do jogo desde o menu de pausa
func _on_sair_pressed() -> void:
	get_tree().quit()


# vai para a tela principal desde o menu de pausa
func _on_retornar_para_tela_inicial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")

#abre a receita atual
func _on_briefing_pressed() -> void:
	if(ControleDeFase.receita_selecionada):
		briefing.iniciar(false, ControleDeFase.receita_selecionada.nome)
	else:
		briefing.iniciar(false)

#abre a aba de controles
func _on_control_pressed() -> void:
	briefing.iniciar(false, "controles")

#abre a aba de controles
func _on_config_pressed() -> void:
	##Essa seria a tela de configurações de volumes q hj em dia eh a tela inicial, nao sei como alterar isso no momento
	return
