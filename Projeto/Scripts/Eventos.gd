extends Node

signal EventoIniciado(evento)
signal EventoFalhou(evento)
signal EventoRealizado(evento)
signal EventoFinalizado(evento)

const Cenas := {
	"cortar-alimento": preload("res://UI/Eventos/CortarAlimento.tscn"),
	"pegar_ingrediente": preload("res://UI/Eventos/Geladeira.tscn"),
	"finalizar-fase": preload("res://UI/Menus/MenuFimDeJogo.tscn")
}
