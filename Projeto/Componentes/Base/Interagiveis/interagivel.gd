class_name Interagivel
extends Node2D

signal interagir(jogador: Player)
signal entrar_no_alcance(jogador: Player)
signal sair_do_alcance(jogador: Player)

static var _interagiveis_no_alcance = []
var sprites_para_contornar := []
var jogador_no_alcance: Player:
	set(valor):
		jogador_no_alcance = valor
		
		if jogador_no_alcance != null:
			_interagiveis_no_alcance.append(self)
		else:
			_interagiveis_no_alcance.erase(self)
		
		_interagiveis_no_alcance.sort_custom(func (a: BaseInteragivel, b: BaseInteragivel):
			return a.prioridade_de_interacao >= b.prioridade_de_interacao
		)

var pode_interagir := true:
	set(valor):
		pode_interagir = valor

var esta_coletado := false:
	set(valor):
		esta_coletado = valor
		
		if esta_coletado:
			jogador_no_alcance = null
			visible = false

var esta_contornado := false:
	set(valor):
		if esta_contornado == valor:
			return
		
		esta_contornado = valor
		var valor_alpha_final = 1.0 if valor else 0.0
		cor_do_contorno.a = 0.0 if valor_alpha_final else 1.0
		
		create_tween()\
			.tween_method(
				transparencia_contorno,
				cor_do_contorno.a,
				valor_alpha_final,
				transicao_contorno_em_segundos)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_ease(Tween.EASE_OUT)

@export var nome: String = ""
@export var descricao : String = ""

@export_subgroup("Interação")
@export var area_de_interacao: CollisionObject2D
@export var prioridade_de_interacao := 0

@export_subgroup("Contorno ao entrar na área")
@export var possui_contorno := true
@export var buscar_contorno_a_partir_de_node: Node
@export var cor_do_contorno := Color("005aa4")
@export var espessura_do_contorno := 20
@export var transicao_contorno_em_segundos := 0.15

const OUTLINE_SHADER = preload("res://Shaders/outline2D_outer.gdshader")

func _ready():
	cor_do_contorno.a = 1.0 if esta_contornado else 0.0
	
	if buscar_contorno_a_partir_de_node == null:
		buscar_contorno_a_partir_de_node = self
	
	sprites_para_contornar = NodeExtension.filter_children(buscar_contorno_a_partir_de_node,
		func(n): return n is Sprite2D or n is AnimatedSprite2D)
	
	if sprites_para_contornar == null or sprites_para_contornar.size() == 0:
		possui_contorno = false
	else:
		for sprite in sprites_para_contornar:
			var shader_material := ShaderMaterial.new()
			shader_material.shader = OUTLINE_SHADER
			shader_material.set_shader_parameter("line_color", cor_do_contorno)
			shader_material.set_shader_parameter("line_thickness", espessura_do_contorno)
			sprite.material = shader_material
	
	if area_de_interacao == null:
		area_de_interacao = NodeExtension.find_first_child(self,
			func(n): return n is CollisionObject2D)
	
	if area_de_interacao != null:
		area_de_interacao.body_entered.connect(_ao_entrar_na_area)
		area_de_interacao.body_exited.connect(_ao_sair_da_area)

func _process(_delta):
	if jogador_no_alcance == null or esta_coletado:
		return
	
	if pode_interagir and Input.is_action_just_pressed("action"):
		if _interagiveis_no_alcance.size() > 1 and _interagiveis_no_alcance[0] != self:
			return
		
		interagir.emit(jogador_no_alcance)

func _ao_entrar_na_area(entidade):
	if entidade is not Player:
		return
	
	jogador_no_alcance = entidade
	entrar_no_alcance.emit(entidade)
	
	if not pode_interagir:
		return
	
	if possui_contorno:
		esta_contornado = true

func _ao_sair_da_area(entidade):
	if entidade is not Player:
		return
	
	jogador_no_alcance = null
	sair_do_alcance.emit(entidade)
	
	if not pode_interagir:
		return
	
	if possui_contorno:
		esta_contornado = false

func transparencia_contorno(value: float) -> void:
	for sprite in sprites_para_contornar:
		cor_do_contorno.a = value
		sprite.material.set_shader_parameter("line_color", cor_do_contorno)
