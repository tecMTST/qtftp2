extends Node

@warning_ignore("unused_signal")
signal evento_iniciado(evento)
signal evento_falhou(evento)
signal evento_realizado(evento)
signal evento_finalizado(evento)

const CENAS := {
	"geladeira": preload("res://UI/Eventos/Geladeira.tscn"),
	"cortar-alimento": preload("res://UI/Eventos/CortarAlimento.tscn"),
	"desenformar-cuscuz": preload("res://UI/Eventos/DesenformarCuscuz.tscn"),
	"finalizar-fase": preload("res://UI/Menus/MenuFimDeJogo.tscn")
}
