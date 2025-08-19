extends Node

signal prato_entregue(prato)
signal nivel_iniciado(nivel, estado_nivel)
signal nivel_concluido(nivel, estado_nivel)
signal nivel_concluido_falha(nivel, estado_nivel)
signal cena_final(nivel, estado_nivel)
signal nova_receita(receita)

@export var nivel_atual : Nivel
@export var jogador : Player
@export var receitas_disponiveis : Array[Receita] = []
@export var receita_selecionada : Receita
@export var ingredientes_disponiveis : Array[Ingrediente] = []
@export var passo_atual : PassoReceita

var tempo_jogo: Timer
var estado_nivel: EstadoDoNivel
var _tempo_checagem: Timer
var _index_receita_atual : int = 0
var _index_passo_atual : int = 0


func _ready() -> void:
	get_tree().paused = false
	_tempo_checagem = Timer.new()
	_tempo_checagem.wait_time = 0.1
	_tempo_checagem.autostart = false
	_tempo_checagem.one_shot = false
	_tempo_checagem.connect("timeout", _verificar_condicoes)
	tempo_jogo = Timer.new()
	tempo_jogo.wait_time = 1
	tempo_jogo.autostart = false
	tempo_jogo.one_shot = true
	tempo_jogo.connect("timeout", _verificar_condicoes)
	add_child(tempo_jogo)
	add_child(_tempo_checagem)

func carregar_nivel():
	var id_nivel = EstadoDeJogo.nivel_atual
	if id_nivel == 0:
		EstadoDeJogo.nivel_atual = 1
		id_nivel = 1
	var niveis = Globais.niveis.filter(func(item : Nivel) : return item.id == id_nivel)
	if len(niveis) > 0:
		nivel_atual = niveis[0]
		receitas_disponiveis = Globais.receitas.filter(
			func(item : Receita) : return nivel_atual.id_receitas.any(
				func(id : int): return id == item.id))
		selecionar_receita_aleatoria()

	jogador = NodeExtension.find_first_child(get_tree().current_scene,
		func(child): return child is Player)

func selecionar_receita_aleatoria() -> void:
	selecionar_receita(randi() % receitas_disponiveis.size())

func selecionar_receita(indice_receita) -> bool:
	if not nivel_atual:
		return false
	if indice_receita > len(receitas_disponiveis) - 1 or indice_receita < 0:
		return false
	_index_receita_atual = indice_receita
	receita_selecionada = receitas_disponiveis[_index_receita_atual]
	ingredientes_disponiveis = Globais.ingredientes.filter(
		func(item : Ingrediente): return receita_selecionada.ingredientes.any(
			func(o) : return item.id == o.id_ingrediente))
	_index_passo_atual = 0
	passo_atual = receita_selecionada.passos[_index_passo_atual]
	print_debug("receita atual: ", _index_receita_atual, " (", receita_selecionada.nome, ")")
	nova_receita.emit(receita_selecionada)
	return true


func proximo_passo() -> bool:
	if not receita_selecionada:
		return false
	_index_passo_atual += 1
	if _index_passo_atual > len(receita_selecionada.passos) - 1:
		_index_receita_atual += 1
		return selecionar_receita(_index_receita_atual)
	passo_atual = receita_selecionada.passos[_index_passo_atual]
	return true

func iniciar_nivel():
	get_tree().paused = false
	assert(nivel_atual is Nivel, "nivel_atual precisa ser carregado")
	_reset_timers() # Verifica e para os timers caso em andamento
	tempo_jogo.wait_time = nivel_atual.tempo
	estado_nivel = EstadoDoNivel.new(nivel_atual)
	tempo_jogo.start()
	_tempo_checagem.start()
	nivel_iniciado.emit(nivel_atual, estado_nivel)
	print_debug("Nível iniciado")


func _atualizar_bagunca() -> void:
	estado_nivel.bagunca = get_tree().get_node_count_in_group('bagunca')


func _verificar_condicoes():
	estado_nivel.tempo_restante = tempo_jogo.time_left
	_atualizar_bagunca()
	if estado_nivel.baguncado():
		_encerrar_nivel_falha()
		print_debug("Nível falhou")
	elif tempo_jogo.is_stopped():
		_encerrar_nivel_falha()
		print_debug("Nível falhou")
	elif estado_nivel.choro_limite():
		_encerrar_nivel_falha()
		print_debug("Nível falhou")	
	elif estado_nivel.completo():
		_cena_final()
		print_debug("Nível completo")
	elif estado_nivel.finalizado():
		_encerrar_nivel()
		print_debug("Nível finalizado")


func entregar_prato(prato: Ingrediente) -> void:
	estado_nivel.entregar_prato(prato)
	prato_entregue.emit(prato)

func _cena_final():
	cena_final.emit(nivel_atual, estado_nivel)

func _encerrar_nivel():
	nivel_concluido.emit(nivel_atual, estado_nivel)
	_reset_timers()
	get_tree().paused = true
	ControleDeAudio.para_musica()
	var efeito = "vitoria" if estado_nivel.completo() else "derrota"
	ControleDeAudio.toca_efeito(efeito)
	EstadoDeJogo.nivel_atual += 1	
	_abrir_proximo_nivel()
	
func _encerrar_nivel_falha():
	_reset_timers()
	get_tree().paused = true
	ControleDeAudio.para_musica()
	var efeito = "vitoria" if estado_nivel.completo() else "derrota"
	ControleDeAudio.toca_efeito(efeito)
	nivel_concluido_falha.emit(nivel_atual, estado_nivel)
	
func _abrir_proximo_nivel():
	var niveis = Globais.niveis.filter(func(item : Nivel) : return item.id == EstadoDeJogo.nivel_atual)
	if len(niveis) > 0:
		nivel_atual = niveis[0]		
		#TODO Remover este loop e direcionar para a sequencia da casa
		EstadoDeJogo.nivel_atual = 1
		#LOOP da fase da casa
		get_tree().paused = false
		get_tree().change_scene_to_file(niveis[0].local)

			
func _reset_timers() -> void:
	if not tempo_jogo.is_stopped():
		tempo_jogo.stop()
	if not _tempo_checagem.is_stopped():
		_tempo_checagem.stop()

func congelar_tempo() -> void:
	jogador.process_mode = Node.PROCESS_MODE_DISABLED
	tempo_jogo.paused = true

func descongelar_tempo() -> void:
	jogador.process_mode = Node.PROCESS_MODE_INHERIT
	tempo_jogo.paused = false
