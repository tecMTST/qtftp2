class_name MenuPausa extends Control

signal continuar

@export var briefing : Briefing

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

#abre o briefing novamente
func _on_briefing_pressed() -> void:
	if(ControleDeFase.receita_selecionada):
		briefing.iniciar(false, ControleDeFase.receita_selecionada.nome)
	else:
		briefing.iniciar(false)
