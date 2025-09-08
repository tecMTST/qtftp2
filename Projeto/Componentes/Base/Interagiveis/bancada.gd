class_name Bancada extends BaseInteragivel

var _jogador : Player

func _ready() -> void:
	nome = "Bancada"
	acao = "Finalizar"
	Eventos.evento_realizado.connect(_on_acao_bancada)
	Eventos.evento_finalizado.connect(_on_acao_bancada_cancelada)
	Eventos.evento_falhou.connect(_on_acao_bancada_cancelada)


func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.objeto_agarrado != null and _jogador == null:
		var objeto_ingrediente = jogador.objeto_agarrado
		if objeto_ingrediente.ingrediente.acoes[0].alvo == "bancada":
			_jogador = jogador
			if objeto_ingrediente.ingrediente.acoes[0].evento != "":
				Eventos.evento_iniciado.emit(objeto_ingrediente.ingrediente.acoes[0].evento)
			else: # se não há evento, vai direto pra _on_acao_bancada().
				Eventos.evento_realizado.emit()


func _on_acao_bancada():
	if(_jogador):
		_jogador.objeto_agarrado.acao_bancada()
		_jogador = null
		print("Acao bancada finalizada!")


func _on_acao_bancada_cancelada():
	if(_jogador):
		_jogador = null
		print("Acao bancada cancelada!")
