extends Node

const TEXTURAS = [
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-01.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-02.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-03.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-04.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-05.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-06.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-07.svg",
	"res://Recursos/Graficos/Personagens/NPC/filaNPCs-08.svg",
]

@export var pessoa: PackedScene
@export var posicao_inicial: Vector2
@export var distancia_entre_pessoas: int
@export var variacao_maxima_horizontal: int
@export var maximo_na_fila: int
@export var pessoas_iniciais_na_fila: int
@export var tempo_minimo_proxima_pessoa: float
@export var tempo_maximo_proxima_pessoa: float

var fila = []

@onready var timer: Timer = $Timer

func _ready():
	for n in range(pessoas_iniciais_na_fila):
		adiciona_pessoa_na_fila()
		_mudar_contador_pessoa()
	ativa_fila_aleatoriamente()

func _mudar_contador_pessoa():
	get_parent().get_node("Counter/TextCounter").text = str(fila.size())

func ativa_fila_aleatoriamente() -> void:
	var tempo_variavel = randf_range(tempo_minimo_proxima_pessoa, tempo_maximo_proxima_pessoa)
	assert(tempo_variavel > 0.0, "fila precisa de intervalo definido")
	print_debug("[fila] próxima pessoa entra em ", tempo_variavel)
	timer.wait_time = tempo_variavel
	timer.start()

func _on_hora_de_entrar_na_fila() -> void:
	adiciona_pessoa_na_fila()
	ativa_fila_aleatoriamente()

func adiciona_pessoa_na_fila() -> void:
	# TODO: fim de jogo se fila.size() > maximo_na_fila
	if fila.size() > maximo_na_fila:
		ControleDeFase.estado_nivel.limite_fila_atingido = true
		return
	var textura_nova = load(TEXTURAS[randi_range(0, TEXTURAS.size() - 1)])
	var pessoa_nova = pessoa.instantiate()
	pessoa_nova.texture = textura_nova
#	pessoa_nova.position = posicao_inicial + Vector2(0, fila.size() * distancia_entre_pessoas)
	add_child(pessoa_nova)
	fila.append(pessoa_nova)
	_mudar_contador_pessoa()
	pessoa_nova.position = get_parent().position + posicao_inicial + Vector2(
		randi_range(-variacao_maxima_horizontal, +variacao_maxima_horizontal),
		(fila.size() - 1) * distancia_entre_pessoas
	)

func remove_pessoa_da_fila() -> bool:
	if fila.is_empty(): return false
	var pessoa_atendida = fila.pop_front()
	var tween = create_tween()
	tween.tween_property(pessoa_atendida, "modulate", Color(1,1,1,1), 0.2)
	tween.tween_property(pessoa_atendida, "modulate", Color(1,1,1,0), 0.5)
	tween.play()
	await tween.finished
	pessoa_atendida.queue_free()
	atualiza_posicoes_na_fila()
	_mudar_contador_pessoa()
	return true


func atualiza_posicoes_na_fila() -> void:
	for i in range(fila.size()):
		fila[i].position = get_parent().position + posicao_inicial + Vector2(
			randi_range(-variacao_maxima_horizontal, +variacao_maxima_horizontal),
			i * distancia_entre_pessoas
		)
