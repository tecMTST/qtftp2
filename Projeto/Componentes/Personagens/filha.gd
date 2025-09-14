class_name Filha
extends Personagem

@export var bagunca_scene: PackedScene
@export var waypoints : Node2D

var target: Marker2D = null
var speed: float = 100.0

# Controle de índice e direção
var waypoint_index := 0
var moving_forward := true

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: CarolinaRig = $carolina_rig
@onready var visualizador_percentual: VisualizadorPercentual = $VisualizadorPercentual
@onready var bt_player: BTPlayer = $BTPlayer


func _ready():
	#if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.bagunca:
	#	sprite.sentada = true
	#	return
	#else:
	bt_player.active = true
	sprite.sentada = false
	ControleDeFase.prato_entregue.connect(_ir_comer)
	visualizador_percentual.valor = 0

func _process(delta):
	#if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.bagunca:
	#	return
		
	if not (target and global_position.distance_to(target.global_position) < agent.target_desired_distance):
		move_along_path(delta)
	visualizador_percentual.valor_maximo = ControleDeFase.estado_nivel.limite_bagunca
	visualizador_percentual.valor = ControleDeFase.estado_nivel.bagunca
	rotation = 0


func mover():
	target = null
	sprite.celular = false
	sprite.sentada = false	
	await get_tree().create_timer(1.0).timeout
	select_new_waypoint()

func celular():
	target = null
	sprite.celular = true

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

func spawn_bagunca():
	if bagunca_scene and target:
		var bagunca = bagunca_scene.instantiate()
		bagunca.global_position = global_position
		get_tree().current_scene.add_child(bagunca)

func _ir_comer(_prato) -> void:
	print_debug('Ir comer')
