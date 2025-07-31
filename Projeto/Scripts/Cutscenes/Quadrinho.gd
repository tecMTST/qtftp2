class_name Quadrinho extends Node

@export var posicaoBounceInicial : Node2D
@export var velocidadeBounce : float = 1
@export var duracaoFadeAlfa : float = 0

var posicaoBounceFinal : Vector2 = Vector2.ZERO
var quadrinhoSprite : Sprite2D
var tempoDeFade : float

func _ready() -> void:
	quadrinhoSprite = get_node("QuadrinhoSprite")

func AtivarQuadrinho() -> void:
	self.visible = true
	print("ativando quadrinho")
	if(duracaoFadeAlfa > 0):
		tempoDeFade = 0

func _process(delta: float) -> void:
	if(!self.visible): return
	if(posicaoBounceFinal == Vector2.ZERO): return
	
	if(posicaoBounceInicial):
		_movimentar_bounce()
		
	if(duracaoFadeAlfa > 0):
		tempoDeFade += delta
		_atualizar_transparencia()

func Configurar_quadrinho() -> void:
	self.visible = false
	posicaoBounceFinal = quadrinhoSprite.global_position
	
	if(posicaoBounceInicial):
		quadrinhoSprite.global_position = posicaoBounceInicial.global_position

func _movimentar_bounce() -> void:
	var vetorDelta = posicaoBounceFinal - quadrinhoSprite.global_position
	var vetorFinal = vetorDelta * (velocidadeBounce/10)
	quadrinhoSprite.global_position += vetorFinal

func _atualizar_transparencia() -> void:
	quadrinhoSprite.modulate.a = tempoDeFade / duracaoFadeAlfa
