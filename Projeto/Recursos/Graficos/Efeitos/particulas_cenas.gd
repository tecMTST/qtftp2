class_name ParticulasCenas
extends Node2D

@export var particle_nodes: Array[GPUParticles2D]
@export var self_destruct_time: float = 2.0

func disparar():
	for particles in particle_nodes:
		if particles is GPUParticles2D:
			await get_tree().create_timer(0.01).timeout
			particles.emitting = true

	await get_tree().create_timer(self_destruct_time).timeout
	queue_free()
