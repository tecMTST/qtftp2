class_name Filha
extends Personagem

@export var bagunca_scene: PackedScene
@export var waypoints : Node2D
@export var cutscene : bool = false

var target: Marker2D = null
var speed: float = 100.0

# Controle de índice e direção
var waypoint_index := 0
var moving_forward := true

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var carolina_rig: CarolinaRig = $carolina_rig
@onready var visualizador_percentual: VisualizadorPercentual = $VisualizadorPercentual
@onready var bt_player: BTPlayer = $BTPlayer

func _ready():
	if (
		cutscene
		or not ControleDeFase.nivel_atual
		or not ControleDeFase.nivel_atual.bagunca
	):
		carolina_rig.sentada = true
		return
	bt_player.active = true
	carolina_rig.sentada = false
	ControleDeFase.prato_entregue.connect(_ir_comer)
	visualizador_percentual.valor = 0

func _process(delta):
	if not cutscene:
		if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.bagunca:
			return
	if not (
		target and global_position.distance_to(
			target.global_position
		) < agent.target_desired_distance
	):
		move_along_path(delta)
	else:
		velocity = Vector2.ZERO
	if not cutscene:
		visualizador_percentual.valor_maximo = ControleDeFase.estado_nivel.limite_bagunca
		visualizador_percentual.valor = ControleDeFase.estado_nivel.bagunca
	rotation = 0

func mover_para(waypoint : String):
	target = null
	carolina_rig.celular = false
	carolina_rig.sentada = false
	await get_tree().create_timer(1.0).timeout
	var markers := waypoints.get_children()
	waypoint_index = markers.find_custom(func(f:Node2D): return f.name == waypoint)
	select_new_waypoint()

func mudar_rosto(rosto : String):
	carolina_rig.mudar_rosto(rosto)

func olhar_para(direcao : String):
	carolina_rig.olhar_para(direcao)

func animacao(nome_anim : String):
	carolina_rig.animacao_direta(nome_anim)

func ordem(index : int):
	z_index = index

func mover():
	target = null
	carolina_rig.celular = false
	carolina_rig.sentada = false
	await get_tree().create_timer(1.0).timeout
	select_new_waypoint()

func parar():
	target = null
	
func ajuntar():
	target = null
	carolina_rig.ajuntar()

func celular():
	target = null
	carolina_rig.celular = true
	
func sentar():
	target = null
	carolina_rig.sentar(true)
	
func levantar():
	target = null
	carolina_rig.levantar(false)

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

func spawn_bagunca():
	if bagunca_scene and target:
		var bagunca = bagunca_scene.instantiate() as Node2D
		bagunca.global_position = global_position
		bagunca.z_index = 4
		get_tree().current_scene.add_child(bagunca)

func _ir_comer(_prato) -> void:
	print_debug('Ir comer')


func _on_topo_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		z_index = 30


func _on_base_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		z_index = 10
