class_name EstadoDoNivel

var tempo_restante : float:
	set(tempo):
		tempo_restante = tempo
		if (
			!ControleDeFase.nivel_atual
			or ControleDeFase.nivel_atual.tempo == ControleDeFase.TEMPO_INFINITO
		):
			tempo_restante_formatado = "∞"
		else:
			var minutes = int(tempo / 60)
			var seconds = fmod(tempo, 60)
			tempo_restante_formatado = "%02d:%02d" % [minutes, seconds]
var tempo_restante_formatado : String
var receitas_nivel : int
var pratos_necessarios : int
var pratos_entregues := []
var bagunca := 0
var limite_bagunca : int
var limite_fila_atingido: bool
var limite_choro_atingido : bool
var cena_final_iniciada : bool
var cena_final_concluida : bool


func _init(nivel : Nivel):
	tempo_restante = nivel.tempo
	receitas_nivel = len(nivel.id_receitas)
	pratos_necessarios = nivel.quantidade_pratos_real
	limite_bagunca = nivel.limite_bagunca
	limite_choro_atingido = false
	limite_fila_atingido = false


func motivo() -> String:
	if completo():
		EstadoDeJogo.nivel_atual += 1
		return "Nível concluído!"
	if baguncado():
		return "Tudo bagunçado."
	if choro_limite():
		return "Atenção ao bebê."
	if fila_limite():
		return "Fila ficou grande demais"
	return "Tempo encerrado!"


func entregar_prato(prato) -> void:
	pratos_entregues.append(prato)
	if !completo(): ControleDeFase.selecionar_proxima_receita()

func completo() -> bool:
	return pratos_entregues.size() >= pratos_necessarios and not cena_final_iniciada

func finalizado() -> bool:
	return cena_final_concluida

func baguncado() -> bool:
	return bagunca >= limite_bagunca

func choro_limite() -> bool:
	return limite_choro_atingido

func fila_limite() -> bool:
	return limite_fila_atingido
