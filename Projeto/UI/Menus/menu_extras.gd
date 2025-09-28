extends Node2D

@onready var opcoes = get_node("menu_opcoes")


func _on_botao_cartilha_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br/wp-content/uploads/2024/08/cartilha-exigibilidade-do-direito-a-estar-livre-da-fome.pdf") # gdlint:ignore=max-line-length


func _on_fechar_extras_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")
	
func _ready() -> void:
	opcoes.visible = false
	$tap2.visible = false
	
	
func _on_opcoes_pressed() -> void:
	$tap1.visible = false
	$tap2.visible = true
	$menu_extra.visible = false
	opcoes.visible = true
	
func _on_estrela_pressed() -> void:
	$tap1.visible = true
	$tap2.visible = false
	opcoes.visible = false
	$menu_extra.visible = true
	

func _on_botao_alianca_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br")
