extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var waypoints = get_parent().get_node("Waypoints")
@onready var sprite: Sprite2D = $Sprite2D  # ou AnimatedSprite2D
@export var bagunca_scene: PackedScene

var target: Marker2D = null
var speed: float = 100.0

# Controle de índice e direção
var waypoint_index := 0
var moving_forward := true

func _ready():
	if not ControleDeFase.NivelAtual or not ControleDeFase.NivelAtual.Bagunca:
		return
	select_new_waypoint()
	ControleDeFase.PratoEntregue.connect(_ir_comer)

func _process(delta):
	if not ControleDeFase.NivelAtual or not ControleDeFase.NivelAtual.Bagunca:
		return
	if target and global_position.distance_to(target.global_position) < agent.target_desired_distance:
		spawn_bagunca()
		target = null
		await get_tree().create_timer(1.0).timeout
		select_new_waypoint()
	else:
		move_along_path(delta)

func move_along_path(delta):
	if agent.is_navigation_finished():
		return

	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed

	# 🔁 Rotacionar suavemente o personagem para a direção do movimento
	var target_angle = direction.angle()
	rotation = lerp_angle(rotation, target_angle, delta * 5.0)  # 5.0 = velocidade da rotação

	move_and_slide()

func select_new_waypoint():
	var markers := waypoints.get_children()
	if markers.is_empty():
		return

	target = markers[waypoint_index]
	agent.set_target_position(target.global_position)

	if moving_forward:
		waypoint_index += 1
		if waypoint_index >= markers.size():
			waypoint_index = markers.size() - 2
			moving_forward = false
	else:
		waypoint_index -= 1
		if waypoint_index < 0:
			waypoint_index = 1
			moving_forward = true

func spawn_bagunca():
	if bagunca_scene and target:
		var bagunca = bagunca_scene.instantiate()
		bagunca.global_position = target.global_position
		get_tree().current_scene.add_child(bagunca)

func _ir_comer(prato) -> void:
	print_debug('Ir comer')
