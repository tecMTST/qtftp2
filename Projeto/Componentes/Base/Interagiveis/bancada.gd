class_name Bancada extends BaseInteragivel

var _jogador : Player

func _ready() -> void:
	Nome = "Bancada"
	Eventos.EventoRealizado.connect(_on_desenformar_realizado)
	Eventos.EventoFinalizado.connect(_on_desenformar_cancelado)
	Eventos.EventoFalhou.connect(_on_desenformar_cancelado)
	
func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.objeto_agarrado != null and _jogador == null:
		var objetoIngrediente = jogador.objeto_agarrado
		if objetoIngrediente.Ingrediente.Acoes[0].Alvo == "bancada":
			_jogador = jogador
			Eventos.EventoIniciado.emit("desenformar-cuscuz")

func _on_desenformar_realizado():
	if(_jogador):
		_jogador.objeto_agarrado.desenformar()
		_jogador = null
		print("cuscuz desenformado!")
	
func _on_desenformar_cancelado():
	if(_jogador):
		_jogador = null
		print("desenforma cancelada")
