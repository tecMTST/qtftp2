extends Node2D

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("fade_splash")
	await get_tree().create_timer(0.5).timeout
	ControleDeAudio.toca_efeito("splash_screen")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")
