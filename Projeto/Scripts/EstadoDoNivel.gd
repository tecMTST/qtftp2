class_name EstadoDoNivel

var tempo_restante : float:
	set(tempo):
		var minutes = int(tempo / 60)
		var seconds = fmod(tempo, 60)
		tempo_restante_formatado = "%02d:%02d" % [minutes, seconds]
		tempo_restante = tempo
var tempo_restante_formatado : String
var receitas_nivel : int
var pratos_necessarios : int
var pratos_entregues := []
var bagunca := 0
var limite_bagunca : int
var limite_choro_atingido : bool


func _init(nivel : Nivel):
	tempo_restante = nivel.tempo
	receitas_nivel = len(nivel.id_receitas)
	pratos_necessarios = nivel.quantidade_pratos_real
	limite_bagunca = nivel.limite_bagunca
	limite_choro_atingido = false


func motivo() -> String:
	if completo():
		EstadoDeJogo.nivel_atual += 1
		return "Nível concluído!"
	if baguncado():
		return "Tudo bagunçado."
	if choro_limite():
		return "Atenção ao bebê."
	return "Tempo encerrado!"


func entregar_prato(prato) -> void:
	pratos_entregues.append(prato)


func completo() -> bool:
	return pratos_entregues.size() >= pratos_necessarios


func baguncado() -> bool:
	return bagunca >= limite_bagunca


func choro_limite() -> bool:
	return limite_choro_atingido
