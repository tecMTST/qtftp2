class_name ObjIngrediente extends Control

signal botao_apertado

@export var Nome = ""
@export var Descricao = ""
@export var CaminhoObjeto = ""
@export var Sprite: Texture

func _ready() -> void:
	$Sprite.texture = Sprite

func _on_button_button_up() -> void:
	botao_apertado.emit()
