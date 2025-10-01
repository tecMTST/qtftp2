extends Node2D

# Export an array to assign all your GPUParticles2D nodes
@export var particle_nodes: Array[CPUParticles2D]
# Export the time in seconds before this scene deletes itself
@export var self_destruct_time: float = 2.0

func _ready():
	# Emit all particles in the list
	for particles in particle_nodes:
		if particles is CPUParticles2D:
			particles.emitting = true
	
	# Wait for the given time and then delete the scene
	await get_tree().create_timer(self_destruct_time).timeout
	queue_free()
