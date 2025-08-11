class_name ComponenteInteragivel
extends Interagivel

func _ready():
	if buscar_contorno_a_partir_de_node == null:
		buscar_contorno_a_partir_de_node = get_parent()

	if area_de_interacao == null:
		area_de_interacao = NodeExtension.find_first_child(get_parent(),
			func(n): return n is CollisionObject2D)

	super._ready()
