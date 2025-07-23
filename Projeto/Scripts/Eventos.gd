extends Node

signal EventoIniciado(evento)
signal EventoFalhou(evento)
signal EventoRealizado(evento)
signal EventoFinalizado(evento)

const Cenas := {
	"cortar-alimento": preload("res://UI/Eventos/CortarAlimento.tscn"),
	"finalizar-fase": preload("res://UI/Menus/MenuFimDeJogo.tscn"),
	"desenformar-cuscuz": preload("res://UI/Eventos/DesenformarCuscuz.tscn")
}
