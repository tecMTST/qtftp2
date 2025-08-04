extends Control

var musica_master = AudioServer.get_bus_index("Master")

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")


func _on_controle_audio_changed() -> void:
	pass # Replace with function body.
