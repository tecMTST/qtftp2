extends Node

signal prato_entregue(prato)
signal nivel_iniciado(nivel, estado_nivel)
signal nivel_concluido(nivel, estado_nivel)
signal nivel_concluido_falha(nivel, estado_nivel)
signal cena_final(nivel, estado_nivel)
signal nova_receita(receita)

const TEMPO_INFINITO = -1

@export var nivel_atual: Nivel
@export var jogador: Player
@export var receitas_disponiveis: Array[Receita] = []
@export var receita_selecionada: Receita
@export var ingredientes_disponiveis: Array[Ingrediente] = []
@export var passo_atual: PassoReceita
@export var indicador_proximo : String = ""

var tempo_jogo: Timer
var estado_nivel: EstadoDoNivel
var _tempo_checagem: Timer
var _indice_receita_atual: int = 0
var _indice_passo_atual: int = 0


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
		_indice_receita_atual = -1
		receitas_disponiveis = []
		for id_receita in nivel_atual.id_receitas:
			for receita in Globais.receitas:
				if id_receita == receita.id:
					receitas_disponiveis.append(receita)
					break
		selecionar_proxima_receita()
	EstadoDeJogo.cena_atual = nivel_atual.local
	jogador = NodeExtension.find_first_child(
		get_tree().current_scene,
		func(child): return child is Player
	)

func trapaca_muda_receita() -> void:
	get_node("/root/Casa/Cozinha/Fogao").ao_tempo_queimado_atingido(null)
	receitas_disponiveis = Globais.receitas
	selecionar_receita_especifica((_indice_receita_atual + 1) % receitas_disponiveis.size())


func selecionar_proxima_receita() -> bool:
	if nivel_atual.ordem_aleatoria:
		return selecionar_receita_aleatoria()
	assert(
		_indice_receita_atual < receitas_disponiveis.size(),
		"receitas em ordem precisam estar todas presentes na lista"
	)
	return selecionar_receita_especifica(_indice_receita_atual + 1)


func selecionar_receita_aleatoria() -> bool:
	if(len(receitas_disponiveis)>0):
		return selecionar_receita_especifica(randi() % receitas_disponiveis.size())
	return false


func selecionar_receita_especifica(indice_receita) -> bool:
	if not nivel_atual:
		return false
	if indice_receita > len(receitas_disponiveis) - 1 or indice_receita < 0:
		return false
	_indice_receita_atual = indice_receita
	receita_selecionada = receitas_disponiveis[_indice_receita_atual]
	ingredientes_disponiveis = Globais.ingredientes.filter(
		func(item : Ingrediente): return receita_selecionada.ingredientes.any(
			func(o) : return item.id == o.id_ingrediente))
	print_debug("receita atual: ", _indice_receita_atual, " (", receita_selecionada.nome, ")")
	carrega_passo_inicial()
	nova_receita.emit(receita_selecionada)
	return true


func carrega_passo_inicial() -> bool:
	_indice_passo_atual = -1
	return proximo_passo()


func proximo_passo() -> bool:
	if not receita_selecionada || _indice_passo_atual > len(receita_selecionada.passos) - 1:
		return false
	_indice_passo_atual += 1
	passo_atual = receita_selecionada.passos[_indice_passo_atual]
	print(
		" => iniciando passo ", _indice_passo_atual, ": ",
		passo_atual.descricao,
		" (", passo_atual.alvo, ")"
	)
	indicador_proximo = passo_atual.alvo
	return true

func verifica_proximo_ponto(alvo : String) -> bool:
	return indicador_proximo == alvo

func iniciar_nivel():
	get_tree().paused = false
	assert(nivel_atual is Nivel, "nivel_atual precisa ser carregado")
	_reset_timers() # Verifica e para os timers caso em andamento
	tempo_jogo.wait_time = nivel_atual.tempo if nivel_atual.tempo > 0 else 1
	estado_nivel = EstadoDoNivel.new(nivel_atual)
	tempo_jogo.start()
	_tempo_checagem.start()
	nivel_iniciado.emit(nivel_atual, estado_nivel)
	print_debug("Nível ", nivel_atual.id, " iniciado")


func _atualizar_bagunca() -> void:
	estado_nivel.bagunca = get_tree().get_node_count_in_group('bagunca')


func _verificar_condicoes():
	estado_nivel.tempo_restante = tempo_jogo.time_left
	_atualizar_bagunca()
	if estado_nivel.baguncado():
		_encerrar_nivel_falha()
		print_debug("Nível falhou")
	elif tempo_jogo.is_stopped() and nivel_atual.tempo != TEMPO_INFINITO:
		_encerrar_nivel_falha()
		print_debug("Nível falhou")
	elif estado_nivel.choro_limite() or estado_nivel.fila_limite():
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
	ControleDeAudio.toca_efeito("alimento_servido")

func _cena_final():
	cena_final.emit(nivel_atual, estado_nivel)

func _encerrar_nivel():
	nivel_concluido.emit(nivel_atual, estado_nivel)
	_reset_timers()
	get_tree().paused = true
	ControleDeAudio.para_musica()
	ControleDeAudio.toca_efeito("vitoria")
	_abrir_proximo_nivel()
	indicador_proximo = ""

func _encerrar_nivel_falha():
	_reset_timers()
	get_tree().paused = true
	ControleDeAudio.para_musica()
	ControleDeAudio.toca_efeito("derrota")
	nivel_concluido_falha.emit(nivel_atual, estado_nivel)

func _abrir_proximo_nivel():
	EstadoDeJogo.nivel_atual += 1
	var niveis = Globais.niveis.filter(
		func(item : Nivel) : return item.id == EstadoDeJogo.nivel_atual
	)
	if len(niveis) == 0:
		EstadoDeJogo.cena_atual = "res://Cenas/cutscene_quadrinhos_epilogo.tscn"
	else:
		nivel_atual = niveis[0]
		EstadoDeJogo.cena_atual = nivel_atual.local
	get_tree().paused = false
	get_tree().change_scene_to_file(EstadoDeJogo.cena_atual)

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

func fase_atual() -> int:
	return EstadoDeJogo.nivel_atual
