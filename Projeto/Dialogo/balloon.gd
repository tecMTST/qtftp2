class_name DialogueBalloon
extends Node2D

const BALLOON_Y_MARGIN := 20

@export var next_action: StringName = &"ui_accept"
@export var skip_action: StringName = &"ui_cancel"

var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		if not next_dialogue_line:
			queue_free()
			return

		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line
		character_label.visible = not dialogue_line.character.is_empty()

		previous_character = current_character
		current_character = ArrayExtension.find_first(characters, func(p: Personagem):
			return p.id == dialogue_line.character)

		if current_character != null:
			if current_character.referencia_de_colisao_para_dialogo != null:
				current_character_collision = current_character.referencia_de_colisao_para_dialogo
			else:
				current_character_collision = NodeExtension.find_first_child(current_character,
					func(child): return child is CollisionShape2D)
			character_label.text = tr(current_character.nome, "dialogue")
		else:
			character_label.text = tr(dialogue_line.character, "dialogue")

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line
		responses_menu.hide()
		responses_menu.responses = dialogue_line.responses
		balloon.show()
		will_hide_balloon = false
		dialogue_label.show()
		character_label.hide()

		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time
			if dialogue_line.time == "auto":
				time = dialogue_line.text.length() * 0.02
			else:
				time = dialogue_line.time.to_float()

			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line

var characters: Array[Personagem]
var current_character: Personagem
var previous_character: Personagem
var current_character_collision: CollisionShape2D
var resource: DialogueResource
var temporary_game_states: Array = []
var is_waiting_for_input: bool = false
var will_hide_balloon: bool = false
var screen_half_size: Vector2
var _locale := TranslationServer.get_locale()

@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var arrow: Sprite2D = $Arrow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var balloon_initial_x := balloon.position.x
@onready var balloon_rect := balloon.get_rect()

func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	animation_player.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	if current_character != null and previous_character != current_character:
		_adjust_balloon_position_according_to_current_character()

func _on_animation_finished(_animation_name):
	dialogue_label.is_typing = true

func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if (
		what == NOTIFICATION_TRANSLATION_CHANGED
		and _locale != TranslationServer.get_locale()
		and is_instance_valid(dialogue_label)
	):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)

		if visible_ratio < 1:
			dialogue_label.skip_typing()

func start(dialogue_resource: DialogueResource, title: String, extra_states: Array = []) -> void:
	var dialogue_characters := NodeExtension.filter_children(get_tree().current_scene,
		func(child): return child is Personagem)

	for character_name in dialogue_resource.character_names:
		if characters.any(func(c): return c.id == character_name):
			continue

		var character = ArrayExtension.find_first(
			dialogue_characters,
			func(dialogue_character: Personagem):
				return dialogue_character.id == character_name
		)

		if character == null:
			continue

		characters.append(character)

	temporary_game_states =  [self] + extra_states
	is_waiting_for_input = false
	resource = dialogue_resource
	var camera_2d = NodeExtension.find_first_child(get_tree().current_scene,
		func(child): return child is Camera2D)
	screen_half_size = (get_viewport_rect().size * 0.5)

	if camera_2d != null:
		screen_half_size = screen_half_size / camera_2d.zoom

	visible = true
	next(title)

func next(next_id: String) -> void:
	dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)

	if current_character != null and previous_character != current_character:
		_adjust_balloon_position_according_to_current_character()
		animation_player.play("popup")
		return

	_adjust_ballon_position_to_bottom()

func _adjust_balloon_position_according_to_current_character():
	visible = true
	arrow.visible = true
	var collision := current_character_collision

	if collision:
		var height := 0

		if collision.shape is CapsuleShape2D:
			height = collision.shape.height
		elif collision.shape is CircleShape2D:
			height = collision.shape.radius
		else:
			height = collision.shape.size.y

		global_position = Vector2(
			collision.global_position.x,
			collision.global_position.y + (height * .5)
		)

func _adjust_ballon_position_to_bottom() -> void:
	visible = true
	arrow.visible = false
	global_position = Vector2(
		screen_half_size.x - screen_half_size.x / 2,
		screen_half_size.y
	)

func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)

func _on_balloon_gui_input(event: InputEvent) -> void:
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = (
			event is InputEventMouseButton
			and event.button_index == MOUSE_BUTTON_LEFT
			and event.is_pressed()
		)
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	get_viewport().set_input_as_handled()

	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		next(dialogue_line.next_id)
	elif (
		event.is_action_pressed(next_action)
		and get_viewport().gui_get_focus_owner() == balloon
	):
		next(dialogue_line.next_id)

func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

func remove():
	animation_player.play_backwards("popup")
	animation_player.animation_finished.connect(_maybe_destroy_animation)

func _maybe_destroy_animation(animation_name) -> void:
	if animation_name == "popup": queue_free()
