class_name Quadrinho extends Node

@export var posicaoBounceInicial : Node2D
@export var velocidadeBounce : float = 1
@export var duracaoFadeAlpha : float = 0

var posicaoBounceFinal : Vector2 = Vector2.ZERO
var quadrinhoRect : TextureRect

func _ready() -> void:
	quadrinhoRect = get_node("QuadrinhoRect")

func AtivarQuadrinho() -> void:
	self.visible = true
	
func _process(delta: float) -> void:
	if(!self.visible): return
	if(posicaoBounceFinal == Vector2.ZERO): return
	
	if(posicaoBounceInicial):
		_movimentar_bounce()

func Configurar_quadrinho() -> void:
	self.visible = false
	posicaoBounceFinal = quadrinhoRect.global_position
	
	if(posicaoBounceInicial):
		quadrinhoRect.global_position = posicaoBounceInicial.global_position

func _movimentar_bounce() -> void:
	var vetorDelta = posicaoBounceFinal - quadrinhoRect.global_position
	var vetorFinal = vetorDelta * (velocidadeBounce/10)
	quadrinhoRect.global_position += vetorFinal
	if(vetorFinal.y > 1):
		print(vetorFinal.y)
