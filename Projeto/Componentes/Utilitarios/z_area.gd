extends Area2D

@onready var area_parent = self.get_parent()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "ZArea":
		var other_parent = area.get_parent()
		if area_parent.global_position.y <= other_parent.global_position.y:
			print("Back Ordered")
			area_parent.z_index = 1
			other_parent.z_index = 2
		elif area_parent.global_position.y >= other_parent.global_position.y:
			print("Front Ordered")
			area_parent.z_index = 2
			other_parent.z_index = 1
