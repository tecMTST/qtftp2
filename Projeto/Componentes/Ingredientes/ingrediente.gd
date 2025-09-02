# essa é a representação do ingrediente dentro da geladeira.
# ao ser escolhido (_on_button_pressed) ele indica qual foi
# o ingrediente escolhido.
class_name ObjIngrediente extends Control

signal ingrediente_escolhido(ingrediente)

@export var descricao = ""
@export var sprite: Texture

var ingrediente: Ingrediente

func _ready() -> void:
	$Sprite.texture = sprite

func _on_button_pressed() -> void:
	ingrediente_escolhido.emit(ingrediente)
