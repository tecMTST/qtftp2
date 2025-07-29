extends Node
class_name BotaoPendulo

@export_range(0.0, 5., 0.1, "suffix:s", "or_greater") var miss_time: float = 0.5
@export var pendulo : MovimentoPendulo

@onready var progress: QuickTimerProgressBar = get_parent()
@onready var miss_timer := Timer.new()

func _ready() -> void:
	assert(progress is QuickTimerProgressBar)
	miss_timer.wait_time = miss_time
	miss_timer.one_shot = false
	miss_timer.timeout.connect(progress.do_miss)
	add_child(miss_timer)

func press() -> void:
	if(pendulo._estaNoAlcanceCerto()):
		miss_timer.start()
		progress.do_act()
	else:
		progress.do_miss()
