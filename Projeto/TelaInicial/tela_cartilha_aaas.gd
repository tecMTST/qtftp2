extends Node2D




func _on_siteaaas_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br")


func _on_cartilha_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br/wp-content/uploads/2024/08/cartilha-exigibilidade-do-direito-a-estar-livre-da-fome.pdf")

#volta para o menu principal
func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/menu_principal.tscn")
