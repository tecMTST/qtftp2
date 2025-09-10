class_name IngredienteBase extends StaticBody2D

signal ao_transformar_sucesso(novo_objeto: IngredienteBase)
signal ao_transformar_falha()
signal ao_tempo_limite_atingido(objeto: IngredienteBase)

enum EstadoIngrediente {
	INICIAL,
	PRONTO_PARA_COZINHAR,
	COZINHANDO,
	QUEIMANDO
}

var id: String = ""
var descricao: String = ""
var ingrediente: Ingrediente
var tempo: int = 0
var estado_atual = EstadoIngrediente.INICIAL

@onready var timer: Timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	assert(
		ResourceLoader.exists(ingrediente.caminho_sprite),
		id + " com imagem inválida: " + ingrediente.caminho_sprite
	)
	var nova_textura = load(ingrediente.caminho_sprite)
	# FIXME: idealmente os sprites tme o mesmo tamanho e não preciso fazer isso.
	# FIXME: ou então usamos um TextureRect em vez do Sprite2D
	var tamanho_textura = nova_textura.get_size()
	var escala_x = 64 / tamanho_textura.x
	var escala_y = 64 / tamanho_textura.y
	var escala_final = min(escala_x, escala_y)
	sprite.scale = Vector2(escala_final, escala_final)
	sprite.texture = nova_textura

	if tempo:
		timer.start(tempo)


func iniciar(ingrediente_dados: Ingrediente) -> void:
	id = ingrediente_dados.id
	descricao = ingrediente_dados.descricao
	ingrediente = ingrediente_dados
	tempo = ingrediente_dados.tempo
	print_debug("--> novo ingrediente: " + id + " (" + descricao + ")")


func _on_timer_timeout():
	assert(
		estado_atual != EstadoIngrediente.PRONTO_PARA_COZINHAR,
		"se estou pronto para cozinhar, não deve haver timer ativo"
	)
	match estado_atual:
		EstadoIngrediente.INICIAL:
			estado_atual = EstadoIngrediente.PRONTO_PARA_COZINHAR
			timer.paused = true
			visualizador_temporal.cor = Color("47dc00") # verde!
		EstadoIngrediente.COZINHANDO:
			estado_atual = EstadoIngrediente.QUEIMANDO
			visualizador_temporal.cor = Color("e83637") # vermelho!
			timer.start(ingrediente.tempo_queima)
		EstadoIngrediente.QUEIMANDO:
			print_debug("queimou! tem que tirar de cena")
		_:
			print_debug("estado " + estado_atual + " inválido")
	ao_tempo_limite_atingido.emit(self)


func _liga_captura_de_eventos() -> void:
	Eventos.evento_realizado.connect(_on_evento_realizado)
	Eventos.evento_falhou.connect(_on_evento_falhou)
	Eventos.evento_finalizado.connect(_on_evento_falhou)


func _desliga_captura_de_eventos() -> void:
	Eventos.evento_realizado.disconnect(_on_evento_realizado)
	Eventos.evento_falhou.disconnect(_on_evento_falhou)
	Eventos.evento_finalizado.disconnect(_on_evento_falhou)


# transforma o ingrediente em outro
func transformar() -> void:
	_liga_captura_de_eventos()
	if ingrediente.acoes[0].evento and ingrediente.acoes[0].evento != "depositar":
		Eventos.evento_iniciado.emit(ingrediente.acoes[0].evento)
	else:
		Eventos.evento_realizado.emit()

func _on_evento_falhou() -> void:
	_desliga_captura_de_eventos()
	ao_transformar_falha.emit(self)

func _on_evento_realizado() -> void:
	_desliga_captura_de_eventos()
	var id_novo_ingrediente = ingrediente.acoes[0].resultado
	var dados_ingrediente = Globais.obtem_ingrediente(id_novo_ingrediente)
	assert(dados_ingrediente != null, "ingrediente " + id_novo_ingrediente + " não encontrado")

	print_debug("[TRANSFORMAR] ", id_novo_ingrediente, " carregado como ", dados_ingrediente.id)
	var novo_ingrediente: IngredienteBase = load(
		"res://Componentes/Ingredientes/IngredienteBase.tscn"
	).instantiate()
	novo_ingrediente.iniciar(dados_ingrediente)
	get_parent().add_child(novo_ingrediente)
	novo_ingrediente.global_position = global_position
	ControleDeFase.proximo_passo()
	ao_transformar_sucesso.emit(novo_ingrediente)
	queue_free()


func _process(_delta: float) -> void:
	global_rotation = 0


func entregar() -> void:
	print_debug("entregando")
	_desliga_captura_de_eventos()
	ControleDeFase.entregar_prato(self.ingrediente)
	queue_free()
