class_name CondicaoDialogo

signal condicao_satisfeita(condicao: CondicaoDialogo)

var linha_dialogo: String
var tempo_espera: int
var agarrou: int
var prato_entregue: int
var signal_nivel: String

var contador_agarrou: int = 0

func init() -> void:
	condicao_satisfeita.connect(_limpar_condicao_satisfeita)

	if agarrou > 0:
		ControleDeFase.jogador.acao_agarrou.connect(_agarrou)
		return
	if prato_entregue > 0:
		ControleDeFase.prato_entregue.connect(_pratos_entregues)
		return
	match signal_nivel:
		"concluido":
			ControleDeFase.nivel_concluido.connect(_acao_nivel)
			return
		"concluido_falha":
			ControleDeFase.nivel_concluido_falha.connect(_acao_nivel)
			return
		"cena_final":
			ControleDeFase.cena_final.connect(_acao_nivel)
			return
	condicao_satisfeita.emit(self)

func _acao_nivel(_nivel, _estado_nivel) -> void:
	condicao_satisfeita.emit(self)

func _agarrou(_ingrediente) -> void:
	contador_agarrou += 1
	if contador_agarrou == agarrou:
		condicao_satisfeita.emit(self)

func _pratos_entregues(_prato) -> void:
	if ControleDeFase.estado_nivel.pratos_entregues.size() == prato_entregue:
		condicao_satisfeita.emit(self)

func _limpar_condicao_satisfeita(_condicao) -> void:
	# desconecta o sinal
	for c in condicao_satisfeita.get_connections():
		condicao_satisfeita.disconnect(c.callable)
	# desconecta os sinais de agarrou e pratos entregues
	if agarrou > 0:
		ControleDeFase.jogador.acao_agarrou.disconnect(_agarrou)
	if prato_entregue > 0:
		ControleDeFase.prato_entregue.disconnect(_pratos_entregues)
	match signal_nivel:
		"concluido":
			ControleDeFase.nivel_concluido.disconnect(_acao_nivel)
		"concluido_falha":
			ControleDeFase.nivel_concluido_falha.disconnect(_acao_nivel)
		"cena_final":
			ControleDeFase.cena_final.disconnect(_acao_nivel)
