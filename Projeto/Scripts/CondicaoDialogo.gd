class_name CondicaoDialogo

signal condicao_satisfeita(condicao: CondicaoDialogo)

var linha_dialogo: String
var tempo_espera: int
var agarrou: int
var prato_entregue: int
var signal_nivel: String

var contador_agarrou: int = 0

func init() -> void:
	if agarrou > 0:
		ControleDeFase.jogador.acao_agarrou.connect(_agarrou)
	if prato_entregue > 0:
		ControleDeFase.prato_entregue.connect(_pratos_entregues)
	match signal_nivel:
		"concluido":
			ControleDeFase.nivel_concluido.connect(_acao_nivel)
		"concluido_falha":
			ControleDeFase.nivel_concluido_falha.connect(_acao_nivel)

func _acao_nivel() -> void:
	condicao_satisfeita.emit(self)

func _agarrou() -> void:
	contador_agarrou += 1
	if contador_agarrou == agarrou:
		condicao_satisfeita.emit(self)

func _pratos_entregues() -> void:
	if ControleDeFase.estado_nivel.pratos_entregues.size() == prato_entregue:
		condicao_satisfeita.emit(self)
