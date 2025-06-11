extends Node

@export var NivelAtual : Nivel
@export var ReceitasDisponiveis : Array[Receita] = []
@export var ReceitaSelecionada : Receita
@export var IngredientesDisponiveis : Array[Ingrediente] = []
@export var PassoAtual : PassoReceita

var jogador : Player
var __indexReceitaAtual : int = 0
var __indexPassoAtual : int = 0

func CarregarNivel(idNivel : int, _jogador: Player):
	var niveis = Globais.Niveis.filter(func(item : Nivel) : return item.Id == idNivel)
	if len(niveis) > 0:
		NivelAtual = niveis[0]
		ReceitasDisponiveis = Globais.Receitas.filter(
			func(item : Receita) : return NivelAtual.IdReceitas.any(
				func(id : int): return id == item.Id))	
		__indexReceitaAtual = 0
		SelecionarReceita(__indexReceitaAtual)
	
	jogador = _jogador

func SelecionarReceita(indexReceita) -> bool:
	if not NivelAtual:
		return	false
	if indexReceita > len(ReceitasDisponiveis) - 1 or indexReceita < 0:
		return false
	ReceitaSelecionada = ReceitasDisponiveis[indexReceita]
	IngredientesDisponiveis = Globais.Ingredientes.filter(
		func(item : Ingrediente): return ReceitaSelecionada.Ingredientes.any(
			func(id : int) : return item.Id == id))
	__indexPassoAtual = 0
	PassoAtual = ReceitaSelecionada.Passos[__indexPassoAtual]
	return true

func ProximoPasso() -> bool:
	if not ReceitaSelecionada:
		return false
	__indexPassoAtual += 1
	if __indexPassoAtual > len(ReceitaSelecionada.Passos) - 1:
		__indexReceitaAtual += 1
		return SelecionarReceita(__indexReceitaAtual)
	PassoAtual = ReceitaSelecionada.Passos[__indexPassoAtual]
	return true
	

 
 
