extends Node
class_name PressButton

@export_range(0.0, 5., 0.1, "suffix:s", "or_greater") var step_time: float = 1.0
@export_range(0.0, 5., 0.1, "suffix:s", "or_greater") var cooldown_time: float = 1.0

@onready var progress: QuickTimerProgressBar = get_parent()
@onready var round_timer: Timer = Timer.new()
@onready var cooldown_timer: Timer = Timer.new()

var pressed := false
var released := true

func _ready() -> void:
	assert(progress is QuickTimerProgressBar)
	round_timer.wait_time = step_time
	round_timer.connect("timeout", _on_round_timeout)
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	cooldown_timer.connect("timeout", _on_cooldown)
	add_child(round_timer)
	add_child(cooldown_timer)

func _on_round_timeout() -> void:
	if pressed:
		progress.do_act()
	else:
		progress.do_miss()

func press() -> void:
	if released:
		cooldown_timer.start()
		progress.do_act()
	pressed = true
	released = false
	round_timer.start()

func release() -> void:
	if not pressed: return
	pressed = false
	round_timer.stop()
	round_timer.start()

func _on_cooldown() -> void:
	released = true
