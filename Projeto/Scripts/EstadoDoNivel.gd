class_name EstadoDoNivel

var TempoRestante : float:
	set(tempo):
		var minutes = int(tempo / 60)
		var seconds = fmod(tempo, 60)
		TempoRestanteFormatado = "%02d:%02d" % [minutes, seconds]
		TempoRestante = tempo
var TempoRestanteFormatado : String
var ReceitasNivel : int
var PratosNecessarios : int
var PratosEntregues := []
var Bagunca := 0
var LimiteBagunca : int

func _init(nivel : Nivel):
	TempoRestante = nivel.Tempo
	ReceitasNivel = len(nivel.IdReceitas)
	PratosNecessarios = nivel.QuantidadePratosReal
	LimiteBagunca = nivel.LimiteBagunca
	
func entregarPrato(prato) -> void:
	PratosEntregues.append(prato)

func completo() -> bool:
	return PratosEntregues.size() >= PratosNecessarios

func baguncado() -> bool:
	return Bagunca >= LimiteBagunca
