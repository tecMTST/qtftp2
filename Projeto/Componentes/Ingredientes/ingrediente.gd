class_name ObjIngrediente extends Control

signal botao_apertado(caminho)

@export var nome = ""
@export var descricao = ""
@export var caminho_objeto = ""
@export var sprite: Texture

func _ready() -> void:
	$Sprite.texture = sprite

func _on_button_pressed() -> void:
	botao_apertado.emit(caminho_objeto)
