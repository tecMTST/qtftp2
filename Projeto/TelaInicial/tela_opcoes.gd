extends Control

var musica_master = AudioServer.get_bus_index("Master")

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/menuprincipal.tscn")
