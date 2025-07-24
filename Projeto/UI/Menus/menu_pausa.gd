class_name MenuPausa extends Control

signal Continue

#essa função despausa o jogo
func _on_continuar_pressed() -> void:
	Continue.emit()
	get_tree().paused = false
	hide()
	
#sai do jogo desde o menu de pausa
func _on_sair_pressed() -> void:
	get_tree().quit()
	
#vai para a tela principal desde o menu de pausa
func _on_retornar_à_tela_inicial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TelaInicial/menu_principal.tscn")
