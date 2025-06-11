extends CharacterBody2D

signal AcaoAtivada
signal AcaoDesativada

@onready var PosicaoObjeto = $PosicaoObjeto
@onready var AreaAcao = $AreaAcao

var interagivelAtivo : Node2D
var acaoExecutando : bool = false
var objetoAgarrado : Node2D
var acaoAgarrar : bool = false

func _input(event: InputEvent) -> void:
	if objetoAgarrado and Input.is_action_just_pressed("action") and not acaoAgarrar:
		acaoAgarrar = true
		agarrar()
	elif objetoAgarrado and Input.is_action_just_pressed("action") and acaoAgarrar:
		acaoAgarrar = false
		soltar()

	if Input.is_action_just_pressed("action") and not acaoExecutando:
		acaoExecutando = true
		_ExecutarAcao()
	elif Input.is_action_just_released("action") and acaoExecutando:
		acaoExecutando = false

func _ExecutarAcao():
	if interagivelAtivo:
		if interagivelAtivo.is_in_group("bancada"):
			print_debug("Acao executada: " + interagivelAtivo.Nome)
			# TODO: Necessário identificar itens no inventário ou nas mãos da personagem?
			Eventos.EventoIniciado.emit('cortar-alimento')
		elif interagivelAtivo.is_in_group("geladeira"):
			print_debug("Acao executada: " + interagivelAtivo.Nome)
			# TODO: Necessário identificar itens no inventário ou nas mãos da personagem?
			Eventos.EventoIniciado.emit('pegar-ingrediente')

func _on_area_acao_body_entered(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not acaoAgarrar:
		objetoAgarrado = body
	elif body.is_in_group("interagivel"):
		interagivelAtivo = body
		AcaoAtivada.emit()

func _on_area_acao_body_exited(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not acaoAgarrar:
		objetoAgarrado = null
	elif body.is_in_group("interagivel"):
		interagivelAtivo = null
		AcaoDesativada.emit()

func agarrar():
	print_debug("Agarrando objeto: " + objetoAgarrado.Nome)
	objetoAgarrado.get_node("CollisionShape2D").disabled = true
	objetoAgarrado.reparent(PosicaoObjeto)
	objetoAgarrado.global_position = PosicaoObjeto.global_position
	objetoAgarrado.global_rotation = PosicaoObjeto.global_rotation

func soltar():
	print_debug("Soltando objeto: " + objetoAgarrado.Nome)
	objetoAgarrado.reparent(get_parent())
	objetoAgarrado.global_position = PosicaoObjeto.global_position
	objetoAgarrado.get_node("CollisionShape2D").disabled = false
	objetoAgarrado = null
