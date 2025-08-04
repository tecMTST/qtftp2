class_name Bancada extends BaseInteragivel

var _jogador : Player

func _ready() -> void:
	Nome = "Bancada"
	Eventos.EventoRealizado.connect(_on_acao_bancada)
	Eventos.EventoFinalizado.connect(_on_acao_bancada_cancelada)
	Eventos.EventoFalhou.connect(_on_acao_bancada_cancelada)
	
func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.objeto_agarrado != null and _jogador == null:
		var objetoIngrediente = jogador.objeto_agarrado
		if objetoIngrediente.Ingrediente.Acoes[0].Alvo == "bancada":
			_jogador = jogador
			if objetoIngrediente.Ingrediente.Acoes[0].Evento != "":
				Eventos.EventoIniciado.emit(objetoIngrediente.Ingrediente.Acoes[0].Evento)

func _on_acao_bancada():
	if(_jogador):
		_jogador.objeto_agarrado.acao_bancada()
		_jogador = null
		print("Acao bancada finalizada!")
	
func _on_acao_bancada_cancelada():
	if(_jogador):
		_jogador = null
		print("Acao bancada cancelada!")
