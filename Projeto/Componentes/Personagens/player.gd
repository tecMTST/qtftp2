class_name Player
extends CharacterBody2D

signal AcaoAtivada
signal AcaoDesativada

@onready var PosicaoObjeto = $PosicaoObjeto
@onready var AreaAcao = $AreaAcao

var itemAtivo : IngredienteBase
var interagivelAtivo : Node2D
var acaoExecutando : bool = false
var acaoAgarrar : bool = false
var objetoAgarrado : ObjetoAgarravel:
	set(valor):
		if valor != null:
			valor.ao_transformar.connect(ao_transformar_objeto_agarrado)
		elif valor == null\
			and objetoAgarrado != null\
			and objetoAgarrado.ao_transformar.is_connected(ao_transformar_objeto_agarrado):
			objetoAgarrado.ao_transformar.disconnect(ao_transformar_objeto_agarrado)
		
		objetoAgarrado = valor

func ao_transformar_objeto_agarrado(novo_objeto: ObjetoAgarravel):
	objetoAgarrado = novo_objeto

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
		print_debug("Acao executada: " + interagivelAtivo.Nome)
		# TODO: Necessário identificar itens no inventário ou nas mãos da personagem?		
		if interagivelAtivo is Geladeira:			
			if not itemAtivo:
				var ingredienteAtual = Globais.GetIngrediente(
					ControleDeFase.PassoAtual.Ingredientes[0].IdIngrediente, 
					ControleDeFase.PassoAtual.Ingredientes[0].VariacaoIngrediente)
				itemAtivo = load(ingredienteAtual.Cena).instantiate()
				add_sibling(itemAtivo)
				objetoAgarrado = itemAtivo
				agarrar()
			else:
				itemAtivo.queue_free()
			
			
			
		elif interagivelAtivo is Bancada:
			pass
		elif interagivelAtivo is Pia:
			pass
		elif interagivelAtivo is Fogao:
			pass

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
