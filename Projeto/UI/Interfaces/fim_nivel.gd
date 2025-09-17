extends Modal

@onready var botao_jogar: Button = %BotaoJogar
@onready var botao_menu: Button = %BotaoMenu

@onready var EstadoNivel := ControleDeFase.EstadoNivel
@onready var modal_title_label: Label = %ModalTitleLabel
@onready var pratos_value: Label = %PratosValue
@onready var bagunca_value: Label = %BaguncaValue


func _ready() -> void:

<<<<<<< Updated upstream
	modal_title_label.text = EstadoNivel.motivo()
	pratos_value.text = str(EstadoNivel.PratosEntregues.size())
	bagunca_value.text = str(EstadoNivel.Bagunca)
=======
	modal_title_label.text = estado_nivel.motivo()
	pratos_value.text = str(estado_nivel.pratos_entregues.size())
	bagunca_value.text = str(estado_nivel.bagunca)
	

>>>>>>> Stashed changes

	
func _on_botao_jogar_button_down() -> void:
	get_tree().reload_current_scene()
