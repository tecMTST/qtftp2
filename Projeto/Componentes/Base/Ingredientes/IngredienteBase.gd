class_name IngredienteBase extends StaticBody2D

signal ao_transformar(novo_objeto: IngredienteBase)

var Ingrediente : Ingrediente
var Nome : String = ""
var Descricao : String = ""

func acao_pia():
	pass

func acao_fogao():
	pass

func acao_bancada():
	pass

func transformar(novo_objeto: IngredienteBase):
	get_parent().add_child(novo_objeto)
	novo_objeto.global_position = global_position
	ao_transformar.emit(novo_objeto)
	queue_free()

func _process(_delta: float) -> void:
	global_rotation = 0

func pode_entregar() -> bool:
	return is_in_group('prato_pronto') and not is_in_group('prato_entregue')

func entregar() -> void:
	if not pode_entregar():
		print_debug('Não pode ser entregue')
		return
	remove_from_group('prato_pronto')
	add_to_group('prato_entregue')
  
