extends Node

const TOM_MAXIMO := 2.4
const INCREMENTO_DE_TOM := 1.2
const TAMANHO_DO_GRUPO_DE_EFEITOS := 4

var tocadores_em_ciclo := {}
var toca_efeitos := []
var biblioteca_de_audio := {
	"musica": {
		"casa_intro": "res://Recursos/Audio/Musica/casa_intro.ogg",
		"casa_loop": "res://Recursos/Audio/Musica/casa_loop.ogg",
		"menu": "res://Recursos/Audio/Musica/musica_menu.ogg",
		"quadrinhos": "res://Recursos/Audio/Musica/cena_introducao.ogg",
		"briefing": "res://Recursos/Audio/Musica/briefing.ogg"
	},
	"efeitos": {
		"vitoria": preload("res://Recursos/Audio/Efeitos/jingle_vitoria.wav") as AudioStream,
		"derrota": preload("res://Recursos/Audio/Efeitos/jingle_derrota.wav") as AudioStream,
		"bebe_chorando": preload("res://Recursos/Audio/Efeitos/bebe_chorando.wav") as AudioStream,
		"bebe_feliz": preload("res://Recursos/Audio/Efeitos/bebe_feliz.wav") as AudioStream,
		"fogao_ligar": preload("res://Recursos/Audio/Efeitos/fogao_ligar.wav") as AudioStream,
		"fogao_cozinhando": preload("res://Recursos/Audio/Efeitos/fogao_cozinhando_loop.wav") as AudioStream,
		"fogao_alarme": preload("res://Recursos/Audio/Efeitos/fogao_alarme.wav") as AudioStream,
		"clique": preload("res://Recursos/Audio/Efeitos/click.wav") as AudioStream,
		"hidratar": preload("res://Recursos/Audio/Efeitos/hidratar.wav") as AudioStream,
		"pegar_item": preload("res://Recursos/Audio/Efeitos/pegar_item.wav") as AudioStream,
		"alimento_servido": preload("res://Recursos/Audio/Efeitos/alimento_servido.wav") as AudioStream,
		"splash_screen": preload("res://Recursos/Audio/Efeitos/splash.wav") as AudioStream,
		"passos": [
			preload("res://Recursos/Audio/Efeitos/passo1.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/passo2.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/passo3.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/passo4.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/passo5.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/passo6.wav") as AudioStream,
		],
		"cortar": [
			preload("res://Recursos/Audio/Efeitos/cut1.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/cut2.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/cut3.wav") as AudioStream,
			preload("res://Recursos/Audio/Efeitos/cut4.wav") as AudioStream,
		],
	}
}

var nome_da_faixa_atual: String
var musica_acelera: bool
var toca_musica_intro: AudioStreamPlayer
var toca_musica_ciclo: AudioStreamPlayer


func _ready() -> void:
	musica_acelera = false
	toca_musica_intro = AudioStreamPlayer.new()
	toca_musica_intro.bus = "Musica"
	add_child(toca_musica_intro)
	toca_musica_intro.finished.connect(_on_intro_finalizada)

	toca_musica_ciclo = AudioStreamPlayer.new()
	toca_musica_ciclo.bus = "Musica"
	toca_musica_ciclo.pitch_scale = 1.0
	add_child(toca_musica_ciclo)
	toca_musica_ciclo.finished.connect(_on_musica_ciclo_completo)

	for i in range(TAMANHO_DO_GRUPO_DE_EFEITOS):
		var tocador = AudioStreamPlayer.new()
		tocador.bus = "Musica"
		add_child(tocador)
		toca_efeitos.append(tocador)

	# preload de recursos de audio não está funcionando corretamente no mobile,
	# então fazemos "na marra" durante o _ready:
	_carrega_efeitos_sonoros()


func _carrega_efeitos_sonoros() -> void:
	for efeito in biblioteca_de_audio["efeitos"].keys():
		var origem = biblioteca_de_audio["efeitos"][efeito]
		if origem is Array:
			var nova_origem = origem.map(_carrega_efeito)
			origem = nova_origem
		else:
			origem = _carrega_efeito(origem)
		biblioteca_de_audio["efeitos"][efeito] = origem


func _carrega_efeito(item) -> AudioStream:
	var carregado = item if item is Resource else load(item)
	AudioServer.register_stream_as_sample(carregado)
	return carregado


func toca_musica(nome_da_faixa: String, acelera: bool = true) -> void:
	musica_acelera = acelera
	if nome_da_faixa_atual == nome_da_faixa:
		print_debug("[ControleDeAudio] musica ", nome_da_faixa, " já está tocando, ignorando.")
		return
	var faixa = biblioteca_de_audio["musica"].get(nome_da_faixa)
	if !faixa:
		print_debug("[ControleDeAudio] caminho para " + nome_da_faixa + " não encontrado.")
		return
	var stream = faixa if faixa is Resource else load(faixa)
	if !stream:
		print_debug("[ControleDeAudio] impossível carregar faixa " + nome_da_faixa)
		return
	para_musica()
	_prepara_musica_ciclo(stream)
	print_debug("[ControleDeAudio] tocando música " + nome_da_faixa)
	toca_musica_ciclo.play()
	nome_da_faixa_atual = nome_da_faixa


func toca_musica_com_intro(nome_intro: String, nome_ciclo: String, acelera: bool = true) -> void:
	musica_acelera = acelera
	var faixa_intro = biblioteca_de_audio["musica"].get(nome_intro)
	var faixa_ciclo = biblioteca_de_audio["musica"].get(nome_ciclo)
	if !faixa_intro || !faixa_ciclo:
		print_debug("[ControleDeAudio] faixas não encontradas: ", nome_intro, ", ", nome_ciclo)
		return
	var intro = faixa_intro if faixa_intro is Resource else load(faixa_intro)
	if !intro:
		print_debug("[ControleDeAudio] impossível carregar faixa intro " + nome_intro)
		return
	var ciclo = faixa_ciclo if faixa_ciclo is Resource else load(faixa_ciclo)
	if !ciclo:
		print_debug("[ControleDeAudio] impossível carregar faixa ciclo " + nome_ciclo)
		return
	para_musica()
	_prepara_musica_ciclo(ciclo)
	toca_musica_intro.stream = intro
	print_debug("[ControleDeAudio] tocando música " + nome_intro + "/" + nome_ciclo)
	toca_musica_intro.play()


func para_musica() -> void:
	print_debug("[ControleDeAudio] parando musica e efeitos em ciclo")
	toca_musica_intro.stop()
	toca_musica_ciclo.stop()
	para_efeitos_em_ciclo()


func toca_efeito(nome_do_efeito: String) -> int:
	var origem = biblioteca_de_audio["efeitos"].get(nome_do_efeito)
	if !origem:
		push_error("efeito '{nome}' não encontrado".format({"nome": nome_do_efeito}))
		return -1

	var stream: AudioStream
	if origem is Array:
		stream = origem[randi() % origem.size()]
	else:
		stream = origem;

	var indice = _encontra_tocador_disponivel()
	if indice == -1: return -1
	var tocador: AudioStreamPlayer = toca_efeitos[indice]
	tocador.stream = stream
	tocador.pitch_scale = 1.0
	tocador.play()
	return indice


func toca_efeito_ciclo(nome_do_efeito: String, nome_ciclo: String) -> void:
	para_efeito_ciclo(nome_ciclo)
	var indice = toca_efeito(nome_do_efeito)
	if indice == -1: return
	var tocador = toca_efeitos[indice]
	tocador.stream.loop = true
	tocadores_em_ciclo[nome_ciclo] = indice

func para_efeitos_em_ciclo() -> void:
	for nome_ciclo in tocadores_em_ciclo.keys():
		para_efeito_ciclo(nome_ciclo)

func para_efeito_ciclo(nome_ciclo: String) -> void:
	if not tocadores_em_ciclo.has(nome_ciclo): return
	var tocador = toca_efeitos[ tocadores_em_ciclo[nome_ciclo] ]
	tocador.stream.loop = false
	tocador.stop()
	tocadores_em_ciclo.erase(nome_ciclo)


func _prepara_musica_ciclo(stream: AudioStream) -> void:
	toca_musica_ciclo.stream = stream
	# nosso loop é manual para podermos ajustar a velocidade da música.
	toca_musica_ciclo.stream.loop = false
	toca_musica_ciclo.pitch_scale = 1.0
	toca_musica_ciclo.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_musica_ciclo_completo() -> void:
	if musica_acelera: _aumenta_velocidade_da_musica()
	toca_musica_ciclo.play()


func _aumenta_velocidade_da_musica() -> void:
	var tom_atual = toca_musica_ciclo.pitch_scale
	if tom_atual == TOM_MAXIMO: return
	tom_atual *= INCREMENTO_DE_TOM
	if tom_atual > TOM_MAXIMO:
		tom_atual = TOM_MAXIMO
		return
	toca_musica_ciclo.pitch_scale = tom_atual


func _on_intro_finalizada() -> void:
	toca_musica_ciclo.play()


func _encontra_tocador_disponivel() -> int:
	for i in range(TAMANHO_DO_GRUPO_DE_EFEITOS):
		if !toca_efeitos[i].playing: return i
	push_warning("Impossível tocar efeito sonoro. Grupo pequeno demais.")
	return -1


func volume_da_musica(volume: float = -1) -> float:
	return _ajusta_volume_do_barramento("Musica", volume)


func volume_de_efeitos(volume: float = -1) -> float:
	return _ajusta_volume_do_barramento("Musica", volume)


func _ajusta_volume_do_barramento(nome_do_barramento: String, volume: float) -> float:
	var indice_do_barramento = AudioServer.get_bus_index(nome_do_barramento)
	if indice_do_barramento < 0:
		print_debug("[ControleDeAudio] barramento " + nome_do_barramento + " não encontrado")
		return -1
	if volume >= 0:
		print_debug("[ControleDeAudio] ajustando ", nome_do_barramento, " para ", volume)
		AudioServer.set_bus_volume_db(indice_do_barramento, linear_to_db(volume))
	return db_to_linear(AudioServer.get_bus_volume_db(indice_do_barramento))


func _on_value_changed(new_value: float) -> void:
	volume_da_musica(new_value)


func _on_value_changed_sfx(new_value: float) -> void:
	volume_de_efeitos(new_value)
