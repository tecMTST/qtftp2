extends Control

var menu_principal = load("res://TelaInicial/menuprincipal.tscn")

func _input(evento: InputEvent) -> void:
	if evento.is_action_pressed("action"):
		_pular_intro()

func _pular_intro() -> void:
	get_tree().change_scene_to_packed(menu_principal)


func _on_texture_button_pressed() -> void:
	_pular_intro()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(menu_principal)
