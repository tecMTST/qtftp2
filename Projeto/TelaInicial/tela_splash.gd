extends Node2D



func _ready() -> void:
	$AudioStreamPlayer2D.play()

func _on_animacao_animation_finished(anim_name: StringName) -> void:
	$AudioStreamPlayer2D.stop() 
	get_tree().change_scene_to_file("res://TelaInicial/parceria.tscn")
	


func _input(evento: InputEvent) -> void:
	if evento.is_action_pressed("action"):
		_pular_intro()

func _pular_intro() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/parceria.tscn")


func _on_texture_button_pressed() -> void:
	_pular_intro()
