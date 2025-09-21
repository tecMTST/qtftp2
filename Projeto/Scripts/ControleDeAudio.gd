extends Node

const TOM_MAXIMO := 2.4
const INCREMENTO_DE_TOM := 1.2
const TAMANHO_DO_GRUPO_DE_EFEITOS := 5

var tocadores_em_ciclo := {}
var toca_efeitos := []
var biblioteca_de_audio := {
	"musica": {
		"casa_intro": preload("res://Recursos/Audio/Musica/casa_intro.ogg"),
		"casa_loop": preload("res://Recursos/Audio/Musica/casa_loop.ogg"),
		"menu": preload("res://Recursos/Audio/Musica/musica_menu.ogg"),
		"quadrinhos": preload("res://Recursos/Audio/Musica/cena_introducao.ogg"),
		"briefing": preload("res://Recursos/Audio/Musica/briefing.ogg")
	},
	"efeitos": {
		"vitoria": preload("res://Recursos/Audio/Efeitos/jingle_vitoria.ogg"),
		"derrota": preload("res://Recursos/Audio/Efeitos/jingle_derrota.ogg"),
		"bebe_chorando": preload("res://Recursos/Audio/Efeitos/bebe_chorando.ogg"),
		"bebe_feliz": preload("res://Recursos/Audio/Efeitos/bebe_feliz.ogg"),
		"fogao_ligar": preload("res://Recursos/Audio/Efeitos/fogao_ligar.ogg"),
		"fogao_cozinhando": preload("res://Recursos/Audio/Efeitos/fogao_cozinhando_loop.ogg"),
		"fogao_alarme": preload("res://Recursos/Audio/Efeitos/fogao_alarme.ogg"),
		"splash_screen": preload("res://Recursos/Audio/Efeitos/splash.ogg"),
		"passos": [
			preload("res://Recursos/Audio/Efeitos/passo1.ogg"),
			preload("res://Recursos/Audio/Efeitos/passo2.ogg"),
			preload("res://Recursos/Audio/Efeitos/passo3.ogg"),
			preload("res://Recursos/Audio/Efeitos/passo4.ogg"),
			preload("res://Recursos/Audio/Efeitos/passo5.ogg"),
			preload("res://Recursos/Audio/Efeitos/passo6.ogg"),
		]
	}
}

var musica_acelera: bool
var efeito_de_pitch: AudioEffectPitchShift
var toca_musica_intro: AudioStreamPlayer
var toca_musica_ciclo: AudioStreamPlayer


func _ready() -> void:
	musica_acelera = false
	toca_musica_intro = AudioStreamPlayer.new()
	toca_musica_intro.bus = "Musica"
	add_child(toca_musica_intro)
	toca_musica_intro.finished.connect(_on_intro_finalizada)

	efeito_de_pitch = AudioEffectPitchShift.new()
	efeito_de_pitch.pitch_scale = 1.0
	efeito_de_pitch.fft_size =AudioEffectPitchShift.FFT_SIZE_2048
	efeito_de_pitch.oversampling = 4
	var indice_do_barramento = AudioServer.get_bus_index("Musica")
	AudioServer.add_bus_effect(indice_do_barramento, efeito_de_pitch, 0)
	AudioServer.set_bus_effect_enabled(indice_do_barramento, 0, true)

	toca_musica_ciclo = AudioStreamPlayer.new()
	toca_musica_ciclo.bus = "Musica"
	toca_musica_ciclo.pitch_scale = 1.0
	add_child(toca_musica_ciclo)
	toca_musica_ciclo.finished.connect(_on_musica_ciclo_completo)

	for i in TAMANHO_DO_GRUPO_DE_EFEITOS:
		var tocador = AudioStreamPlayer.new()
		tocador.bus = "Efeitos"
		add_child(tocador)
		toca_efeitos.append(tocador)


func volume_da_musica(volume: float) -> void:
	_ajusta_volume_do_barramento("Musica", volume)


func volume_de_efeitos(volume: float) -> void:
	_ajusta_volume_do_barramento("Efeitos", volume)


func toca_musica(nome_da_faixa: String, acelera: bool = true) -> void:
	musica_acelera = acelera
	var stream = biblioteca_de_audio["musica"].get(nome_da_faixa)
	if !stream: return
	para_musica()
	_prepara_musica_ciclo(stream)
	toca_musica_ciclo.play()


func toca_musica_com_intro(nome_intro: String, nome_ciclo: String, acelera: bool = true) -> void:
	musica_acelera = acelera
	var intro = biblioteca_de_audio["musica"].get(nome_intro)
	var ciclo = biblioteca_de_audio["musica"].get(nome_ciclo)
	if !intro || !ciclo: return
	para_musica()
	_prepara_musica_ciclo(ciclo)
	toca_musica_intro.stream = intro
	toca_musica_intro.play()


func para_musica() -> void:
	toca_musica_intro.stop()
	toca_musica_ciclo.stop()


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
	efeito_de_pitch.pitch_scale = 1.0
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
	efeito_de_pitch.pitch_scale /= INCREMENTO_DE_TOM
	toca_musica_ciclo.pitch_scale = tom_atual


func _on_intro_finalizada() -> void:
	toca_musica_ciclo.play()


func _encontra_tocador_disponivel() -> int:
	for i in TAMANHO_DO_GRUPO_DE_EFEITOS:
		if !toca_efeitos[i].playing: return i
	push_warning("Impossível tocar efeito sonoro. Grupo pequeno demais.")
	return -1


func _ajusta_volume_do_barramento(nome_do_barramento: String, volume: float) -> void:
	var indice_do_barramento = AudioServer.get_bus_index(nome_do_barramento)
	print_debug("Ajustando ", nome_do_barramento, " para ", volume)
	if indice_do_barramento >= 0:
		AudioServer.set_bus_volume_db(indice_do_barramento, linear_to_db(volume))


func _on_value_changed(new_value: float) -> void:
	ControleDeAudio.volume_da_musica(new_value)

func _on_value_changed_sfx(new_value: float) -> void:
	ControleDeAudio.volume_de_efeitos(new_value)
