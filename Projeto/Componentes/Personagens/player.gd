class_name Player
extends Personagem

signal acao_ativada
signal acao_desativada
signal acao_agarrou(objeto)

var sfx_intervalo_passada: float = 0.35
var sfx_timer: float = 0.0
var interagivel_ativo: Node2D
var acao_executando: bool = false
var esta_agarrando: bool = false
var objeto_agarrado: IngredienteBase:
	set(valor):
		objeto_agarrado = valor

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var top_down_controler_2d: TopDownControler2D = $TopDownControler2D
@onready var pivo_acao: Node2D = $PivoAcao
@onready var posicao_objeto = $PosicaoObjeto
@onready var elza_rig: ElzaRig = $"elza rig"


func ao_transformar_objeto_agarrado(novo_objeto: IngredienteBase):
	soltar()
	agarrar(novo_objeto)

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
	elza_rig.segurando = esta_agarrando

	var velocidade = velocity.x
	rotacao(delta)
	if velocidade > 0:
		elza_rig.scale.x = -abs(elza_rig.scale.x)
		posicao_objeto.position.x = abs(posicao_objeto.position.x)
	elif velocidade < 0:
		elza_rig.scale.x = abs(elza_rig.scale.x)
		posicao_objeto.position.x = -abs(posicao_objeto.position.x)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action") and not acao_executando:
		acao_executando = true
	elif Input.is_action_just_released("action") and acao_executando:
		acao_executando = false
	_trapaceia(event)


func _trapaceia(evento: InputEvent) -> void:
	if !(evento is InputEventKey and evento.is_pressed() and not evento.is_echo()): return
	match evento.keycode:
		KEY_K:
			ControleDeFase.trapaca_muda_receita()
		KEY_J:
			ControleDeFase._encerrar_nivel()
		KEY_1:
			var fila = get_node("/root/CozinhaSolidaria/EntregaNaFila1/Fila")
			if is_instance_valid(fila): fila.adiciona_pessoa_na_fila()
		KEY_2:
			var fila = get_node("/root/CozinhaSolidaria/EntregaNaFila1/Fila")
			if is_instance_valid(fila): fila.remove_pessoa_da_fila()
		KEY_3:
			var fila = get_node("/root/CozinhaSolidaria/EntregaNaFila2/Fila")
			if is_instance_valid(fila): fila.adiciona_pessoa_na_fila()
		KEY_4:
			var fila = get_node("/root/CozinhaSolidaria/EntregaNaFila1/Fila")
			if is_instance_valid(fila): fila.remove_pessoa_da_fila()


func eliminar_ingrediente() -> void:
	esta_agarrando = false
	if objeto_agarrado != null:
		objeto_agarrado.queue_free()
		objeto_agarrado = null


func agarrar(objeto: Node):
	if objeto.get_parent(): objeto.get_parent().remove_child(objeto)
	add_sibling(objeto)
	objeto_agarrado = objeto
	_agarrar()


func _on_area_acao_body_entered(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not esta_agarrando:
		objeto_agarrado = body


func _on_area_acao_body_exited(body: Node2D) -> void:
	if body.is_in_group("agarravel") and not esta_agarrando:
		objeto_agarrado = null


func on_interagivel_entered(body : Node2D) -> void:
	interagivel_ativo = body
	acao_ativada.emit()


func on_interagivel_exited() -> void:
	interagivel_ativo = null
	acao_desativada.emit()


func _agarrar():
	objeto_agarrado.reparent(posicao_objeto)
	objeto_agarrado.ao_transformar_sucesso.connect(ao_transformar_objeto_agarrado)
	objeto_agarrado.get_node("CollisionShape2D").disabled = true
	objeto_agarrado.global_position = posicao_objeto.global_position
	esta_agarrando = true
	acao_agarrou.emit(objeto_agarrado)


func rotacao(_delta : float):
	pivo_acao.look_at(pivo_acao.global_position + top_down_controler_2d.last_direction)


func soltar():
	objeto_agarrado.ao_transformar_sucesso.disconnect(ao_transformar_objeto_agarrado)
	objeto_agarrado.reparent(get_parent())
	objeto_agarrado.get_node("CollisionShape2D").disabled = false
	esta_agarrando = false

func ajuntar():
	elza_rig.ajuntar()

func ativar():
	top_down_controler_2d.Active = true
	elza_rig.ativo = true


func desativar():
	top_down_controler_2d.Active = false
	elza_rig.ativo = false
