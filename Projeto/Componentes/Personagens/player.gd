extends CharacterBody2D

signal AcaoAtivada
signal AcaoDesativada

var interagivelAtivo : Node2D
var acaoExecutando : bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action") and not acaoExecutando:
		acaoExecutando = true
		_ExecutarAcao()	
	elif Input.is_action_just_released("action") and acaoExecutando:
		acaoExecutando = false
		
func _ExecutarAcao():
	if interagivelAtivo:
		print_debug("Acao executada: " + interagivelAtivo.Nome)

func _on_area_acao_body_entered(body: Node2D) -> void:
	if body.is_in_group("interagivel"):
		interagivelAtivo = body
		AcaoAtivada.emit()

func _on_area_acao_body_exited(body: Node2D) -> void:
	if body.is_in_group("interagivel"):
		interagivelAtivo = null
		AcaoDesativada.emit()
