class_name spin_button extends Node2D

signal giro_completo(contador : int)

var contador : int = 0

@onready var botao: Sprite2D = $Botao


func _ready() -> void:
	contador = 0

func _process(_delta: float) -> void:
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		botao.look_at(get_global_mouse_position())
	if rad_to_deg(botao.rotation) >= 360:
		botao.rotation = rad_to_deg(0)
		contador += 1
		giro_completo.emit(contador)
	if rad_to_deg(botao.rotation) < 0:
		botao.rotation = rad_to_deg(0)
