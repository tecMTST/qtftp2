extends Node2D

@onready var botao = $tap/esquerda
@onready var estado_botao = true #true esquerda e false direita
@onready var opcoes = get_node("menu_opcoes")

func _on_botao_cartilha_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br/wp-content/uploads/2024/08/cartilha-exigibilidade-do-direito-a-estar-livre-da-fome.pdf") # gdlint:ignore=max-line-length


func _on_fechar_extras_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")

func _ready() -> void:
	opcoes.visible = false
	var controle_musica: HSlider = opcoes.get_node("control_musica")
	controle_musica.value = ControleDeAudio.volume_da_musica()
	controle_musica.value_changed.connect(Callable(ControleDeAudio, "_on_value_changed"))
	var controle_efeitos: HSlider = opcoes.get_node("control_efeitos")
	controle_efeitos.value = ControleDeAudio.volume_de_efeitos()
	controle_efeitos.value_changed.connect(Callable(ControleDeAudio, "_on_value_changed_sfx"))


func _on_opcoes_pressed() -> void:
	if estado_botao:
		$tap/direita.play("movimento_direita")
		estado_botao = false
	await get_tree().create_timer(0.15).timeout
	$menu_extra.visible = false
	opcoes.visible = true

func _on_estrela_pressed() -> void:
	if !estado_botao:
		$tap/esquerda.play("movimento_esquerda")
		estado_botao = true
	await get_tree().create_timer(0.15).timeout
	opcoes.visible = false
	$menu_extra.visible = true


func _on_botao_alianca_pressed() -> void:
	OS.shell_open("https://alimentacaosaudavel.org.br")
