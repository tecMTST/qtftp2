extends TextureProgressBar
class_name QuickTimerProgressBar

signal started
signal act
signal miss
signal completed
signal failed

@export var event_timer: Timer
@export var behavior: Node

var running := false

func _ready() -> void:
	assert(event_timer is Timer)
	event_timer.connect("timeout", _on_timer_timeout)
	self.connect("value_changed", _on_value_changed)

func start() -> void:
	if not event_timer: return
	if running: return
	value = min_value
	event_timer.paused = false
	event_timer.start()
	running = true
	started.emit()

func stop() -> void:
	event_timer.stop()
	running = false

func _on_timer_timeout() -> void:
	stop()
	failed.emit()

func do_act() -> void:
	if not running: return
	value += step
	act.emit()

func do_miss() -> void:
	if not running: return
	value -= step
	miss.emit()

func _on_value_changed(_value: float) -> void:
	if value >= 100:
		event_timer.paused = true
		running = false
		completed.emit()
