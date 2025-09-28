extends Node2D

func _ready() -> void:
	$LogoAaas.hide()
	$anim_1.play("fade_splash")
	await get_tree().create_timer(0.7).timeout
	ControleDeAudio.toca_efeito("splash_screen")


func _on_anim_1_animation_finished(_anim_name: StringName) -> void:
	$LogoTpt.hide()
	$anim_2.play("fade_alianca")
	$LogoAaas.show()
	


func _on_anim_2_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")
