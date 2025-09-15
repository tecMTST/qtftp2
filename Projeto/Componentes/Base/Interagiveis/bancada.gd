class_name Bancada extends BaseInteragivel

@export var posicao_do_objeto_na_bancada: Vector2 = Vector2(0, 0)


var objeto_na_bancada: IngredienteBase = null
var _jogador: Player

@onready var indicador: Sprite2D = $Indicador

func _ready() -> void:
	nome = "Bancada"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("bancada")


func eliminar_ingrediente() -> void:
	if objeto_na_bancada != null: objeto_na_bancada.queue_free()
	objeto_na_bancada = null
	_jogador = null


func _on_componente_interagivel_interagir(jogador: Player) -> void:
	var objeto = jogador.objeto_agarrado
	print_debug("[bancada]")
	if ControleDeFase.passo_atual.alvo != "bancada":
		print_debug("  [-] não é hora de usar a bancada")
		return
	if (_jogador != null):
		print_debug("  [-] ação em andamento, não posso seguir")
		return
	if objeto == null:
		print_debug("  [-] jogador não está segurando nada")
		if objeto_na_bancada == null:
			var ingrediente_a_criar = ControleDeFase.passo_atual.ingrediente
			if ingrediente_a_criar == null:
				print_debug(" [-] nada a fazer")
				return
			var dados_ingrediente = Globais.obtem_ingrediente(ingrediente_a_criar)
			var novo_ingrediente: IngredienteBase = load(
				"res://Componentes/Ingredientes/IngredienteBase.tscn"
			).instantiate()
			novo_ingrediente.iniciar(dados_ingrediente)
			novo_ingrediente.estado_atual = novo_ingrediente.EstadoIngrediente.PRONTO_PARA_COZINHAR
			jogador.agarrar(novo_ingrediente)
			ControleDeFase.proximo_passo()
			return
		print_debug("  [-] jogador vai pegar ", objeto_na_bancada.descricao)
		objeto = objeto_na_bancada
		objeto.ao_transformar_sucesso.connect(_on_pegar_item_da_bancada)
	else:
		if objeto.ingrediente.acoes[0].alvo != "bancada":
			print_debug("  [-] ", objeto.id, " não interage com bancada")
			return
		print_debug("  [-] jogador segurando ", objeto.descricao)
		if objeto_na_bancada == null:
			if objeto.ingrediente.acoes[0].evento == "depositar":
				print_debug("  [-] nada na bancada. Colocando ingrediente")
				objeto.ao_transformar_sucesso.connect(_on_colocar_item_na_bancada)
			else:
				print_debug("  [-] interagindo com bancada SEM depositar")
				objeto.ao_transformar_sucesso.connect(_on_transformou_sem_deixar)
		else:
			if objeto_na_bancada.ingrediente.acoes[0].alvo != objeto.id:
				print_debug(
					"  [-] bancada tem ", objeto_na_bancada.descricao, " que espera ",
					objeto_na_bancada.ingrediente.acoes[0].alvo,
					" mas personagem está segurando uma ", objeto.id
				)
				return
			print_debug("  [-] bancada com ", objeto_na_bancada.id, ". misturando com ", objeto.id)
			objeto = objeto_na_bancada
			objeto.ao_transformar_sucesso.connect(_on_misturar_itens)
	objeto.ao_transformar_falha.connect(_on_transformar_falhou)
	_jogador = jogador
	objeto.transformar()


func _on_transformou_sem_deixar(_novo_item: IngredienteBase) -> void:
	_jogador = null


func _on_pegar_item_da_bancada(novo_item: IngredienteBase) -> void:
	print_debug("  [-] jogador agarrou ", novo_item.descricao)
	_jogador.agarrar(novo_item)
	_jogador = null
	objeto_na_bancada = null


func _on_colocar_item_na_bancada(novo_item: IngredienteBase) -> void:
	_jogador.soltar()
	_jogador = null
	novo_item.reparent(self)
	novo_item.position = posicao_do_objeto_na_bancada
	objeto_na_bancada = novo_item
	print_debug("  [-] coloquei objeto " + novo_item.id + " na bancada!")


func _on_misturar_itens(novo_item: IngredienteBase) -> void:
	var objeto_antigo = _jogador.objeto_agarrado
	_jogador.soltar()
	objeto_antigo.queue_free()

	# agarrar() faz add_sibling(), que só funciona em nós órfãos.
	novo_item.get_parent().remove_child(novo_item)
	_jogador.agarrar(novo_item)

	_jogador = null
	objeto_na_bancada = null


func _on_transformar_falhou(item_atual: IngredienteBase) -> void:
	if item_atual.ao_transformar_sucesso.is_connected(_on_pegar_item_da_bancada):
		item_atual.ao_transformar_sucesso.disconnect(_on_pegar_item_da_bancada)
	if item_atual.ao_transformar_sucesso.is_connected(_on_colocar_item_na_bancada):
		item_atual.ao_transformar_sucesso.disconnect(_on_colocar_item_na_bancada)
	if item_atual.ao_transformar_sucesso.is_connected(_on_misturar_itens):
		item_atual.ao_transformar_sucesso.disconnect(_on_misturar_itens)
	_jogador = null
	return
