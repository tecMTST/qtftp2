extends Node

signal EventoIniciado(evento)
signal EventoFalhou(evento)
signal EventoRealizado(evento)
signal EventoFinalizado(evento)

const Cenas := {
	"geladeira": preload("res://UI/Eventos/Geladeira.tscn"),
	"cortar-alimento": preload("res://UI/Eventos/CortarAlimento.tscn"),	
	"desenformar-cuscuz": preload("res://UI/Eventos/DesenformarCuscuz.tscn")
	"pegar-ingrediente": preload("res://UI/Eventos/Geladeira.tscn"),
	"finalizar-fase": preload("res://UI/Menus/MenuFimDeJogo.tscn")
}
