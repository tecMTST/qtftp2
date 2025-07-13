extends Node

var biblioteca_de_audio := {
	"musica": {
		"casa_intro": preload("res://Recursos/Audio/Musica/casa_intro.ogg"),
		"casa_loop": preload("res://Recursos/Audio/Musica/casa_loop.ogg"),
	},
	"efeitos": {
		"fogao": preload("res://Recursos/Audio/Efeitos/fogao.wav"),
	}
}

var toca_musica_intro: AudioStreamPlayer
var toca_musica_ciclo: AudioStreamPlayer
var toca_efeitos := []
const TAMANHO_DO_GRUPO_DE_EFEITOS := 5

func _ready() -> void:
	toca_musica_intro = AudioStreamPlayer.new()
	toca_musica_intro.bus = "Musica"
	add_child(toca_musica_intro)
	toca_musica_intro.finished.connect(_on_intro_finalizada)

	toca_musica_ciclo = AudioStreamPlayer.new()
	toca_musica_ciclo.bus = "Musica"
	add_child(toca_musica_ciclo)

	for i in TAMANHO_DO_GRUPO_DE_EFEITOS:
		var tocador = AudioStreamPlayer.new()
		tocador.bus = "Efeitos"
		add_child(tocador)
		toca_efeitos.append(tocador)


func toca_musica(nome_da_faixa: String) -> void:
	var stream = biblioteca_de_audio["musica"].get(nome_da_faixa)
	if !stream: return
	if toca_musica_ciclo.stream != stream:
		para_musica()
		toca_musica_ciclo.stream = stream
		toca_musica_ciclo.stream.loop = true
		toca_musica_ciclo.play()

func toca_musica_com_intro(nome_faixa_intro: String, nome_faixa_ciclo: String) -> void:
	var intro = biblioteca_de_audio["musica"].get(nome_faixa_intro)
	var ciclo = biblioteca_de_audio["musica"].get(nome_faixa_ciclo)

	if !intro || !ciclo: return

	para_musica()

	toca_musica_intro.stream = intro
	toca_musica_ciclo.stream = ciclo
	toca_musica_ciclo.stream.loop = true

	toca_musica_intro.play()


func _on_intro_finalizada() -> void:
	toca_musica_ciclo.play()


func para_musica() -> void:
	toca_musica_intro.stop()
	toca_musica_ciclo.stop()


func toca_efeito(nome_do_efeito: String, variacao_de_tom: float = 0.0) -> void:
	var stream = biblioteca_de_audio["efeitos"].get(nome_do_efeito)
	if !stream: return
	
	# encontra tocador disponível dentro do grupo...
	for tocador in toca_efeitos:
		if !tocador.playing:
			tocador.stream =  stream
			tocador.pitch_scale = 1.0 + randf_range(-variacao_de_tom, variacao_de_tom)
			tocador.play()
			return

	# ...ou cria um temporário se não houver tocador disponível.
	var tocador_temp = AudioStreamPlayer.new()
	tocador_temp.bus = "Efeitos"
	add_child(tocador_temp)
	tocador_temp.stream = stream
	tocador_temp.pitch_scale = 1.0 + randf_range(-variacao_de_tom, variacao_de_tom)
	tocador_temp.play()
	await tocador_temp.finished
	remove_child(tocador_temp)

func volume_da_musica(volume: float) -> void:
	ajusta_volume_do_barramento("Musica", volume)

func volume_de_efeitos(volume: float) -> void:
	ajusta_volume_do_barramento("Efeitos", volume)

func ajusta_volume_do_barramento(nome_do_barramento: String, volume: float) -> void:
	var indice_do_barramento = AudioServer.get_bus_index(nome_do_barramento)
	if indice_do_barramento >= 0:
		AudioServer.set_bus_volume_db(indice_do_barramento, linear_to_db(volume))
