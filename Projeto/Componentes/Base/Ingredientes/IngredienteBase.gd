class_name IngredienteBase extends ObjetoAgarravel

var Ingrediente : Ingrediente

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
