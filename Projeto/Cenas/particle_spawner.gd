class_name ParticleSpawner
extends Node

@export var particle_effects: Array[PackedScene]
@export var particle_names: Array[String]

func _ready():
	add_to_group("spawner_particulas")

func spawn_particle(effect_name: String, spawn_position: Vector2):
	var effect_index = particle_names.find(effect_name)
	if effect_index == -1:
		push_error("Particle effect '" + effect_name + "' not found!")
		return
	if particle_effects[effect_index] == null:
		push_error("Particle scene at index " + str(effect_index) + " is null!")
		return
	var particle_instance = particle_effects[effect_index].instantiate()
	get_tree().current_scene.add_child(particle_instance)
	particle_instance.global_position = spawn_position
	particle_instance.disparar()
	
