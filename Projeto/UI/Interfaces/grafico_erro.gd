extends ColorRect

@export var move_speed := 20.0

@export_range(0, 1) var anim_progress: float = 0.0:
	set(value):
		anim_progress = value
		if material:
			material.set_shader_parameter("progress", anim_progress)

func _ready():
	anim_progress = 0.0
	if material:
		material.set_shader_parameter("progress", anim_progress)

	play_sequence()

func play_sequence():
	var tween = create_tween()

	var forward_time := 0.5
	var hold_time := 0.2
	var reverse_time := 0.5

	tween.tween_property(self, "anim_progress", 1.0, forward_time)

	tween.tween_interval(hold_time)

	tween.tween_property(self, "anim_progress", 0.0, reverse_time)

	tween.finished.connect(func():
		queue_free()
	)

func _process(delta):
	position.y -= move_speed * delta
