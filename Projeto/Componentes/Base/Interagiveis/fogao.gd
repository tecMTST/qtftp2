class_name Fogao extends BaseInteragivel

var objeto_no_fogao: IngredienteBase = null
var _jogador: Player

@onready var indicador: Sprite2D = $Indicador
@onready var pivot_objeto: Node2D = $Pivot
@onready var fogo_animado: AnimatedSprite2D = $AnimatedFire

func _ready() -> void:
	nome = "Fogão"


func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("fogao")


func eliminar_ingrediente() -> void:
	fogo_animado.hide()
	ControleDeAudio.para_efeito_ciclo("fogao_alarme")
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhando")
	if objeto_no_fogao != null: objeto_no_fogao.queue_free()
	objeto_no_fogao = null
	_jogador = null


func _on_componente_interagivel_interagir(jogador: Player) -> void:
	print_debug("[fogao]")
	if (_jogador != null):
		print_debug("  [-] ação em andamento, não posso seguir")
		return

	var objeto_na_mao: IngredienteBase
	if jogador.esta_agarrando:
		objeto_na_mao = jogador.objeto_agarrado
		if objeto_na_mao.estado_atual != objeto_na_mao.EstadoIngrediente.PRONTO_PARA_COZINHAR:
			print_debug("  [-] objeto na mão ainda não está pronto para ferver")
			return

	if(objeto_no_fogao):
		if(objeto_no_fogao.estado_atual == objeto_no_fogao.EstadoIngrediente.COZINHANDO):
			print_debug("  [-] calma! ", objeto_no_fogao.id, " ainda está cozinhando")
			return
		if (objeto_na_mao):
			var indice_acao: int = -1
			for idx in objeto_no_fogao.ingrediente.acoes.size():
				if objeto_no_fogao.ingrediente.acoes[idx].alvo == objeto_na_mao.id:
					indice_acao = idx
					break
			if indice_acao == -1:
				print_debug(
					"  [-] objeto no fogao (", objeto_no_fogao.descricao, ") não espera ",
					objeto_na_mao.id, " que personagem está segurando"
				)
				return
			print_debug(
				"  [-] fogão com ", objeto_no_fogao.id, ". misturando com ", objeto_na_mao.id
			)
			_jogador = jogador
			_misturar_ingredientes_na_panela(indice_acao)
		else:
			_jogador = jogador
			_recolher_objeto()
	else:
		if ControleDeFase.nivel_atual.id == 3:
			var fase03 = "res://Dialogo/Fase03.dialogue"
			ControleDeFase.jogador.iniciar_dialogo(load(fase03), "semgas", 3.0)
		if(!objeto_na_mao):
			print_debug("  [-] jogador sem nada, fogão sem nada... nada pra fazer")
			return
		if objeto_na_mao.ingrediente.acoes[0].alvo == "fogao":
			_jogador = jogador
			_cozinhar_objeto(objeto_na_mao)
		else:
			print_debug("  [-] ", objeto_na_mao.id, " não interage com fogão")
			return

func _misturar_ingredientes_na_panela(indice_acao: int) -> void:
	objeto_no_fogao.ao_transformar_sucesso.connect(_on_misturar_itens)
	objeto_no_fogao.ao_transformar_falha.connect(_on_falhou_transformacao)
	objeto_no_fogao.transformar(indice_acao)

func _on_misturar_itens(novo_item: IngredienteBase) -> void:
	var objeto_antigo = _jogador.objeto_agarrado
	_jogador.soltar()
	objeto_antigo.queue_free()

	# agarrar() faz add_sibling(), que só funciona em nós órfãos.
	#novo_item.get_parent().remove_child(novo_item)
	objeto_no_fogao = novo_item
	_jogador = null


func _recolher_objeto() -> void:
	print_debug("  [-] se preparando pra tirar ", objeto_no_fogao.id, " do fogão")
	print_debug("  [-] que vira ", objeto_no_fogao.ingrediente.acoes[0].resultado)
	objeto_no_fogao.ao_transformar_sucesso.connect(_on_recolher_objeto_do_fogao)
	objeto_no_fogao.ao_transformar_falha.connect(_on_falhou_transformacao)
	objeto_no_fogao.transformar()


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
	objeto_no_fogao = null
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
	objeto_no_fogao = novo_objeto
	objeto_no_fogao.estado_atual = objeto_no_fogao.EstadoIngrediente.COZINHANDO
	objeto_no_fogao.ao_tempo_limite_atingido.connect(ao_tempo_cozimento_atingido)
	objeto_no_fogao.reparent(pivot_objeto)
	objeto_no_fogao.global_position = pivot_objeto.global_position
	fogo_animado.show()
	ControleDeAudio.toca_efeito("fogao_ligar")
	ControleDeAudio.toca_efeito_ciclo("fogao_cozinhando", "fogao_cozinhando")


func ao_tempo_cozimento_atingido(_objeto: IngredienteBase):
	print_debug("  [-] tempo de cozimento atingido!")
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhado")
	ControleDeAudio.toca_efeito("fogao_alarme")
	objeto_no_fogao.ao_tempo_limite_atingido.disconnect(ao_tempo_cozimento_atingido)
	objeto_no_fogao.ao_tempo_limite_atingido.connect(ao_tempo_queimado_atingido)


func ao_tempo_queimado_atingido(_objeto: IngredienteBase):
	print_debug("  [-] ", _objeto.descricao, " queimou no fogão! Recomeçando receita...")
	for interagivel in get_tree().get_nodes_in_group("interagivel"):
		if interagivel.has_method("eliminar_ingrediente"):
			print_debug("  [-] eliminando ingrediente de ", interagivel.name)
			interagivel.eliminar_ingrediente()
			interagivel.eliminar_ingrediente()
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	player.eliminar_ingrediente()
	ControleDeFase.carrega_passo_inicial()
