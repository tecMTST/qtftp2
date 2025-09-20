extends Control

signal escolheu_ingrediente

var acao_executada = false
var player : Player

@onready var prateleira_1 = $VBoxContainer/Prateleira
@onready var prateleira_2 = $VBoxContainer/Prateleira2
@onready var prateleira_3 = $VBoxContainer/Prateleira3
@onready var instancia_ingrediente = preload("res://Componentes/Ingredientes/ingrediente.tscn")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	acao_executada = false


func preencher_geladeira(posicao_do_ingrediente):
	print_debug("[abrindo geladeira]")
	if not ControleDeFase.nivel_atual or not ControleDeFase.receita_selecionada:
		close()
	print_debug("  [+] tenho fase e receita")
	var passo_atual = ControleDeFase.passo_atual
	print_debug("  [+] alvo do passo é ", passo_atual.alvo)
	if passo_atual.alvo != "geladeira": close()
	var id_ingrediente = passo_atual.ingrediente
	assert(id_ingrediente != null, "passo da geladeira precisa de ingrediente!")
	var ingrediente = Globais.obtem_ingrediente(id_ingrediente)
	print_debug("colocando " + id_ingrediente + " na geladeira")
	var ingrediente_geladeira = instancia_ingrediente.instantiate() as ObjIngrediente
	ingrediente_geladeira.ingrediente = ingrediente
	ingrediente_geladeira.sprite = load(ingrediente.caminho_sprite)
	ingrediente_geladeira.ingrediente_escolhido.connect(escolhe_ingrediente)

	# coloca ingrediente em prateleira aleatória
	var container: Node
	container = [
		prateleira_1,
		prateleira_2,
		prateleira_3
	][posicao_do_ingrediente % 3].get_node("IngredienteContainer")
	container.add_child(ingrediente_geladeira)


func close() -> void:
	player.ativar()
	GuiTransitions.hide("Geladeira")
	await get_tree().create_timer(1).timeout
	get_parent().queue_free()
	if ControleDeFase.nivel_atual.id == 3:
		var fase03 = "res://Dialogo/Fase03.dialogue"
		ControleDeFase.jogador.iniciar_dialogo(load(fase03),"geladeiravazia", 3.0)


func escolhe_ingrediente(ingrediente_escolhido: Ingrediente) -> void:
	if player and not acao_executada:
		acao_executada = true
		var ingrediente: IngredienteBase = load(
			"res://Componentes/Ingredientes/IngredienteBase.tscn"
		).instantiate()
		ingrediente.iniciar(ingrediente_escolhido)
		player.agarrar(ingrediente)
		ControleDeAudio.toca_efeito("pegar_item")
		ControleDeFase.proximo_passo()
		ingrediente_escolhido = null
		escolheu_ingrediente.emit()
		close()


func _on_button_pressed() -> void:
	close()
