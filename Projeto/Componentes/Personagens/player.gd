class_name Player
extends Personagem

signal acao_ativada
signal acao_desativada

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var gambiarra_centralizar: Sprite2D = $GambiarraCentralizar
@onready var top_down_controler_2d: TopDownControler2D = $TopDownControler2D
@onready var pivo_acao: Node2D = $PivoAcao
@onready var posicao_objeto = $PosicaoObjeto
@onready var menu_geladeira = preload("uid://ccxw6f3bwr8tt")

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

	var velocidadeAnimacao = remap(abs(velocity.length()),0.0, 600.0, 0.0, 1.0)
	animation_tree.set("parameters/Velocidade/blend_position", velocidadeAnimacao)
	
	var velocidade = velocity.x
	rotacao(delta)
	if velocidade > 0:			
		gambiarra_centralizar.flip_h = true
		posicao_objeto.position.x = abs(posicao_objeto.position.x)
	elif velocidade < 0:
		gambiarra_centralizar.flip_h = false
		posicao_objeto.position.x = -abs(posicao_objeto.position.x)
		
		
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

func agarrar_de_menu(objeto: Node):
	add_sibling(objeto)
	objeto_agarrado = objeto
	agarrar()
	
func _executar_acao():
	if interagivel_ativo:
		# TODO: Necessário identificar itens no inventário ou nas mãos da personagem?
		if interagivel_ativo is Geladeira:
			if not item_ativo:
				var _geladeira = menu_geladeira.instantiate()
				_geladeira.position =  Vector2(350,500)
				add_sibling(_geladeira)
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
	acao_agarrar = true
	
func rotacao(delta : float):	
	var rotacao_atual = pivo_acao.rotation
	pivo_acao.look_at(pivo_acao.global_position + top_down_controler_2d.last_direction)
			
			
func soltar():
	objeto_agarrado.reparent(get_parent())
	objeto_agarrado.get_node("CollisionShape2D").disabled = false
	objeto_agarrado = null
	acao_agarrar = false
