extends Node

signal NivelIniciado(nivel, estado_nivel)
signal NivelConcluido(nivel, estado_nivel)

@export var NivelAtual : Nivel
@export var ReceitasDisponiveis : Array[Receita] = []
@export var ReceitaSelecionada : Receita
@export var IngredientesDisponiveis : Array[Ingrediente] = []
@export var PassoAtual : PassoReceita

var _tempo_checagem: Timer
var __indexReceitaAtual : int = 0
var __indexPassoAtual : int = 0

var TempoJogo: Timer
var EstadoJogo: EstadoDeJogo
var EstadoNivel: EstadoDoNivel

func CarregarNivel(idNivel : int):
	var niveis = Globais.Niveis.filter(func(item : Nivel) : return item.Id == idNivel)
	if len(niveis) > 0:
		NivelAtual = niveis[0]
		ReceitasDisponiveis = Globais.Receitas.filter(
			func(item : Receita) : return NivelAtual.IdReceitas.any(
				func(id : int): return id == item.Id))	
		__indexReceitaAtual = 0
		SelecionarReceita(__indexReceitaAtual)

func SelecionarReceita(indexReceita) -> bool:
	if not NivelAtual:
		return	false
	if indexReceita > len(ReceitasDisponiveis) - 1 or indexReceita < 0:
		return false
	ReceitaSelecionada = ReceitasDisponiveis[indexReceita]
	IngredientesDisponiveis = Globais.Ingredientes.filter(
		func(item : Ingrediente): return ReceitaSelecionada.Ingredientes.any(
			func(id : int) : return item.Id == id))
	__indexPassoAtual = 0
	PassoAtual = ReceitaSelecionada.Passos[__indexPassoAtual]
	return true

func ProximoPasso() -> bool:
	if not ReceitaSelecionada:
		return false
	__indexPassoAtual += 1
	if __indexPassoAtual > len(ReceitaSelecionada.Passos) - 1:
		__indexReceitaAtual += 1
		return SelecionarReceita(__indexReceitaAtual)
	PassoAtual = ReceitaSelecionada.Passos[__indexPassoAtual]
	return true

func _ready() -> void:
	get_tree().paused = false
	_tempo_checagem = Timer.new()
	_tempo_checagem.wait_time = 0.1
	_tempo_checagem.autostart = false
	_tempo_checagem.one_shot = false
	_tempo_checagem.connect("timeout", _verificar_condicoes)
	TempoJogo = Timer.new()
	TempoJogo.wait_time = 1
	TempoJogo.autostart = false
	TempoJogo.one_shot = true
	TempoJogo.connect("timeout", _verificar_condicoes)
	add_child(TempoJogo)
	add_child(_tempo_checagem)

func IniciarNivel():
	get_tree().paused = false
	assert(NivelAtual is Nivel, "NivelAtual precisa ser carregado")
	_reset_timers() # Verifica e para os timers caso em andamento
	TempoJogo.wait_time = NivelAtual.Tempo
	EstadoNivel = EstadoDoNivel.new(NivelAtual)
	TempoJogo.start()
	_tempo_checagem.start()
	NivelIniciado.emit(NivelAtual, EstadoNivel)
	print_debug("Nível iniciado")
	
func _atualizar_bagunca() -> void:
	EstadoNivel.Bagunca = get_tree().get_node_count_in_group('bagunca')

func _verificar_condicoes():
	EstadoNivel.TempoRestante = TempoJogo.time_left
	_atualizar_bagunca()
	if EstadoNivel.baguncado():
		NivelConcluido.emit(NivelAtual, EstadoNivel)
		_encerrar_nivel()
		print_debug("Nível falhou")
	elif TempoJogo.is_stopped():
		if EstadoNivel.completo():
			NivelConcluido.emit(NivelAtual, EstadoNivel)
			_encerrar_nivel()
			print_debug("Nível concluído")
			return
		NivelConcluido.emit(NivelAtual, EstadoNivel)
		_encerrar_nivel()
		print_debug("Nível falhou")

func _encerrar_nivel():
	_reset_timers()
	get_tree().paused = true

func _reset_timers() -> void:
	if not TempoJogo.is_stopped():
		TempoJogo.stop()
	if not _tempo_checagem.is_stopped():
		_tempo_checagem.stop()
