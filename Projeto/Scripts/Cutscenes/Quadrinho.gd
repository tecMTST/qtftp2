class_name Quadrinho extends Node

signal on_quadrinho_finalizado

@export var posicao_bounce_inicial : Node2D
@export var velocidade_bounce : float = 1
@export var duracao_fade_alfa : float = 0

var posicao_bounce_final : Vector2 = Vector2.ZERO
var quadrinho_sprite : Sprite2D
var tempo_de_fade : float
var _bounce_finalizado : bool = false
var _alpha_finalizado : bool = false

func _ready() -> void:
	quadrinho_sprite = get_node("QuadrinhoSprite")
	posicao_bounce_final = quadrinho_sprite.global_position

func ativar_quadrinho() -> void:
	self.visible = true
	if(duracao_fade_alfa > 0):
		tempo_de_fade = 0

func _process(delta: float) -> void:
	if(!self.visible): return
	if(posicao_bounce_final == Vector2.ZERO): return

	if(posicao_bounce_inicial):
		_movimentar_bounce()

	if(duracao_fade_alfa > 0):
		tempo_de_fade += delta
		_atualizar_transparencia()

func configurar_quadrinho() -> void:
	self.visible = false

	if(posicao_bounce_inicial):
		quadrinho_sprite.global_position = posicao_bounce_inicial.global_position

	_bounce_finalizado = !posicao_bounce_inicial
	_alpha_finalizado = duracao_fade_alfa <= 0

func _movimentar_bounce() -> void:
	var vetor_delta = posicao_bounce_final - quadrinho_sprite.global_position
	var vetor_final = vetor_delta * (velocidade_bounce/10)
	quadrinho_sprite.global_position += vetor_final
	if(vetor_delta.length() < .15 and !_bounce_finalizado):
		_bounce_finalizado = true
		_check_se_finalizado()

func _atualizar_transparencia() -> void:
	quadrinho_sprite.modulate.a = tempo_de_fade / duracao_fade_alfa
	if(tempo_de_fade / duracao_fade_alfa >= .9 and !_alpha_finalizado):
		_alpha_finalizado = true
		_check_se_finalizado()

func _check_se_finalizado() -> void:
	if(_alpha_finalizado && _bounce_finalizado):
		on_quadrinho_finalizado.emit()
