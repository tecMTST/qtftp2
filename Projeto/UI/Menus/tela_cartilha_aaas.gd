extends Node2D

func _on_siteaaas_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br")

func _on_cartilha_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br/wp-content/uploads/2024/08/cartilha-exigibilidade-do-direito-a-estar-livre-da-fome.pdf") # gdlint:ignore=max-line-length

#volta para o menu principal
func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")
