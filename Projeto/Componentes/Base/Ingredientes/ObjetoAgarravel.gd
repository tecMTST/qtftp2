class_name ObjetoAgarravel extends StaticBody2D

signal ao_transformar(novo_objeto: ObjetoAgarravel)

var Nome : String = ""
var Descricao : String = ""

func enxaguar():
	pass

func cozinhar():
	pass

func cortar():
	pass

func combinar() -> bool:
	return false

func transformar(novo_objeto: ObjetoAgarravel):
	get_parent().add_child(novo_objeto)
	novo_objeto.global_position = global_position
	ao_transformar.emit(novo_objeto)
	queue_free()
