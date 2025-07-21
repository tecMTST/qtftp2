class_name Player
extends Personagem

signal acao_ativada
signal acao_desativada

@onready var PosicaoObjeto = $PosicaoObjeto
@onready var AreaAcao = $AreaAcao

var sfx_intervalo_passada: float = 0.35
var sfx_timer: float = 0.0
var item_ativo: IngredienteBase
var interagivel_ativo: Node2D
var acao_executando: bool = false
var acao_agarrar: bool = false
var objeto_agarrado: ObjetoAgarravel:
	set(valor):
		if valor != null:
			valor.ao_transformar.connect(ao_transformar_objeto_agarrado)
		elif valor == null\
			and objeto_agarrado != null\
			and objeto_agarrado.ao_transformar.is_connected(ao_transformar_objeto_agarrado):
			objeto_agarrado.ao_transformar.disconnect(ao_transformar_objeto_agarrado)

		objeto_agarrado = valor

@onready var posicao_objeto = $PosicaoObjeto

func ao_transformar_objeto_agarrado(novo_objeto: ObjetoAgarravel):
	objeto_agarrado = novo_objeto

func _physics_process(delta: float) -> void:
	if (Input.is_action_pressed("up")   or
		Input.is_action_pressed("down") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")):
		sfx_timer -= delta
		if sfx_timer <= 0.0:
			ControleDeAudio.toca_efeito("passos")
			sfx_timer = sfx_intervalo_passada
	else:
		sfx_timer = 0.0

func _input(_event: InputEvent) -> void:
	if(!interagivel_ativo):
		if objeto_agarrado and Input.is_action_just_pressed("action") and not acao_agarrar:
			agarrar()
		elif objeto_agarrado and Input.is_action_just_pressed("action") and acao_agarrar:
			soltar()

	if Input.is_action_just_pressed("action") and not acao_executando:
		acao_executando = true
		_executar_acao()
	elif Input.is_action_just_released("action") and acao_executando:
		acao_executando = false

func _executar_acao():
	if interagivel_ativo:
		# TODO: Necessário identificar itens no inventário ou nas mãos da personagem?
		if interagivel_ativo is Geladeira:
			if not item_ativo:
				var ingrediente_atual = Globais.GetIngrediente(
					ControleDeFase.PassoAtual.Ingredientes[0].IdIngrediente,
					ControleDeFase.PassoAtual.Ingredientes[0].VariacaoIngrediente)
				item_ativo = load(ingrediente_atual.Cena).instantiate()
				add_sibling(item_ativo)
				objeto_agarrado = item_ativo
				agarrar()
			else:
				item_ativo.queue_free()
		elif interagivel_ativo is Bancada:
			pass
		elif interagivel_ativo is Pia:
			pass
		elif interagivel_ativo is Fogao:
			pass

func _on_area_acao_body_entered(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not acao_agarrar:
		objeto_agarrado = body
	elif body.is_in_group("interagivel"):
		interagivel_ativo = body
		acao_ativada.emit()

func _on_area_acao_body_exited(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not acao_agarrar:
		objeto_agarrado = null
	elif body.is_in_group("interagivel"):
		interagivel_ativo = null
		acao_desativada.emit()

func agarrar():
	objeto_agarrado.get_node("CollisionShape2D").disabled = true
	objeto_agarrado.reparent(posicao_objeto)
	objeto_agarrado.global_position = posicao_objeto.global_position
	objeto_agarrado.global_rotation = posicao_objeto.global_rotation
	acao_agarrar = true

func soltar():
	objeto_agarrado.reparent(get_parent())
	objeto_agarrado.get_node("CollisionShape2D").disabled = false
	objeto_agarrado = null
	acao_agarrar = false
