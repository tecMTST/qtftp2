extends Node

@warning_ignore("unused_signal")
signal evento_iniciado(evento)

@warning_ignore("unused_signal")
signal evento_falhou(evento)

@warning_ignore("unused_signal")
signal evento_realizado(evento)

@warning_ignore("unused_signal")
signal evento_finalizado(evento)

const CENAS := {
	"geladeira": preload("res://UI/Eventos/Geladeira.tscn"),
	"cortar_alimento": preload("res://UI/Eventos/CortarAlimento.tscn"),
	"desenformar_cuscuz": preload("res://UI/Eventos/DesenformarCuscuz.tscn"),
	"finalizar_fase": preload("res://UI/Menus/MenuFimDeJogo.tscn")
}
