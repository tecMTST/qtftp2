extends Node2D

@export var particle_nodes: Array[CPUParticles2D]
@export var self_destruct_time: float = 2.0

func _ready():
	for particles in particle_nodes:
		if particles is CPUParticles2D:
			particles.emitting = true

	await get_tree().create_timer(self_destruct_time).timeout
	queue_free()
