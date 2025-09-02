class_name Fogao extends BaseInteragivel

var objeto_atual : IngredienteBase = null
var _jogador : Player

@onready var indicador: Sprite2D = $Indicador
@onready var pivot_objeto : Node2D = $Pivot
@onready var fogo_animado : AnimatedSprite2D = $AnimatedFire

func _ready() -> void:
	nome = "Fogão"


func _process(delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("fogao")

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	print_debug("[fogao]")
	if(objeto_atual):
		if(
			jogador.esta_agarrando
			or objeto_atual.estado_atual == objeto_atual.EstadoIngrediente.COZINHANDO
		):
			print_debug("  [-] calma! ", objeto_atual.id, " ainda está cozinhando")
			return
		_jogador = jogador
		_recolher_objeto()
	else:
		if ControleDeFase.nivel_atual.id == 3:
			var fase03 = "res://Dialogo/Fase03.dialogue"
			ControleDeFase.jogador.iniciar_dialogo(load(fase03), "semgas", 3.0)
		if(!jogador.esta_agarrando):
			print_debug("  [-] jogador sem nada, fogão sem nada... nada pra fazer")
			return
		var objeto_ingrediente = jogador.objeto_agarrado
		if objeto_ingrediente.ingrediente.acoes[0].alvo == "fogao":
			_jogador = jogador
			_cozinhar_objeto(objeto_ingrediente)
		else:
			print_debug("  [-] ", objeto_ingrediente.id, " não interage com fogão")
			return


func _recolher_objeto() -> void:
	print_debug("  [-] se preparando pra tirar ", objeto_atual.id, " do fogão")
	print_debug("  [-] que vira ", objeto_atual.ingrediente.acoes[0].resultado)
	objeto_atual.ao_transformar_sucesso.connect(_on_recolher_objeto_do_fogao)
	objeto_atual.ao_transformar_falha.connect(_on_falhou_transformacao)
	objeto_atual.transformar()


func _cozinhar_objeto(objeto : IngredienteBase) -> void:
	print_debug("  [-] se preparando para cozinhar objeto")
	objeto.ao_transformar_sucesso.connect(_on_posicionar_objeto_no_fogao)
	objeto.ao_transformar_falha.is_connected(_on_falhou_transformacao)
	objeto.transformar()


func _on_recolher_objeto_do_fogao(objeto: IngredienteBase) -> void:
	print_debug("  [-] tirando ", objeto.descricao, " do fogão")
	fogo_animado.hide()
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhando")
	_jogador.agarrar(objeto)
	objeto_atual = null
	_jogador = null


func _on_falhou_transformacao(objeto: IngredienteBase) -> void:
	print_debug("  [-] erro ao interagir com fogao")
	objeto.ao_transformar_sucesso.disconnect(_on_posicionar_objeto_no_fogao)
	objeto.ao_transformar_falha.disconnect(_on_falhou_transformacao)
	_jogador = null

func _on_posicionar_objeto_no_fogao(novo_objeto) -> void:
	print_debug("  [-] colocando ", novo_objeto.id, " no fogão")
	_jogador.soltar()
	_jogador = null
	objeto_atual = novo_objeto
	objeto_atual.estado_atual = objeto_atual.EstadoIngrediente.COZINHANDO
	objeto_atual.ao_tempo_limite_atingido.connect(ao_tempo_cozimento_atingido)
	objeto_atual.reparent(pivot_objeto)
	objeto_atual.global_position = pivot_objeto.global_position
	fogo_animado.show()
	ControleDeAudio.toca_efeito("fogao_ligar")
	ControleDeAudio.toca_efeito_ciclo("fogao_cozinhando", "fogao_cozinhando")


func ao_tempo_cozimento_atingido(_objeto: IngredienteBase):
	print_debug("  [-] tempo de cozimento atingido!")
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhado")
	ControleDeAudio.toca_efeito("fogao_alarme")
