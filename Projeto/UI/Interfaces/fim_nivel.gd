extends Modal

@onready var botao_jogar: Button = %BotaoJogar
@onready var botao_menu: Button = %BotaoMenu

@onready var EstadoNivel := ControleDeFase.EstadoNivel
@onready var modal_title_label: Label = %ModalTitleLabel
@onready var pratos_value: Label = %PratosValue
@onready var bagunca_value: Label = %BaguncaValue

func _ready() -> void:
	modal_title_label.text = EstadoNivel.motivo()
	pratos_value.text = str(EstadoNivel.PratosEntregues.size())
	bagunca_value.text = str(EstadoNivel.Bagunca)

func _on_botao_jogar_button_down() -> void:
	get_tree().reload_current_scene()
