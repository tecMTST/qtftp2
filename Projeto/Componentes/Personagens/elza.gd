class_name Elza extends Personagem

@export var waypoints : Node2D

var target: Marker2D = null
var speed: float = 100.0

# Controle de índice e direção
var waypoint_index := 0
var moving_forward := true

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var elza_rig: ElzaRig = $"elza rig"

func _process(delta):
	if not (target and global_position.distance_to(target.global_position) \
	< agent.target_desired_distance):
		move_along_path(delta)
	else:
		velocity = Vector2.ZERO
	rotation = 0

func mover_para(waypoint : String):
	target = null
	elza_rig.segurando = false
	elza_rig.segurando_lucas = false
	elza_rig.amamentando = false
	await get_tree().create_timer(1.0).timeout
	var markers := waypoints.get_children()
	waypoint_index = markers.find_custom(func(f:Node2D): return f.name == waypoint)
	select_new_waypoint()

func mudar_rosto(rosto : String):
	elza_rig.mudar_rosto(rosto)

func olhar_para(direcao : String):
	elza_rig.olhar_para(direcao)

func animacao(nome : String):
	elza_rig.animacao_direta(nome)

func ordem(index : int):
	z_index = index

func mover():
	target = null
	elza_rig.segurando = false
	elza_rig.segurando_lucas = false
	elza_rig.amamentando = false
	await get_tree().create_timer(1.0).timeout
	select_new_waypoint()

func parar():
	target = null

func segurando():
	target = null
	elza_rig.segurando = true

func segurando_lucas():
	target = null
	elza_rig.segurando_lucas = true

func amamentando():
	target = null
	elza_rig.amamentando = true

func move_along_path(delta):
	if agent.is_navigation_finished():
		target = null
		return

	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed

	# 🔁 Rotacionar suavemente o personagem para a direção do movimento
	var target_angle = direction.angle()
	rotation = lerp_angle(rotation, target_angle, delta * 5.0)  # 5.0 = velocidade da rotação

	move_and_slide()

func select_new_waypoint():
	if not waypoints: return
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
