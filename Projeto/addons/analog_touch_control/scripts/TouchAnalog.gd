class_name TouchAnalog extends Node2D

enum ControlPosition {
	Fixed,
	OnTouch
}
@export_category("Touch")
@export var Enabled : bool = true
@export var PositionType : ControlPosition = ControlPosition.Fixed

@export_category("Visual")
@export var ControlsColor : Color = Color.from_rgba8(0,0,0,128) 
@export var CircleTexture : Texture2D = preload("res://addons/analog_touch_control/images/Circle.svg")
@export var KnobTexture : Texture2D = preload("res://addons/analog_touch_control/images/Dot.svg")

@export_category("Input")
@export var Deadzone : float = 15
@export var MaxLenght : float = 50
@export var UpInput : String = "up"
@export var DownInput : String = "down"
@export var LeftInput : String = "left"
@export var RightInput : String = "right"

var posVector: Vector2
var up_event = InputEventAction.new()
var down_event = InputEventAction.new()
var left_event = InputEventAction.new()
var right_event = InputEventAction.new()

var circle: Sprite2D
var knob: AnalogKnob
var button: Button

func _input(event: InputEvent) -> void:
	if PositionType == ControlPosition.OnTouch:
		if event is InputEventScreenTouch:
			if event.is_pressed():			
				position = event.position
				visible = true
				knob.pressing = true
			if event.is_released():
				visible = false
				knob.pressing = false
		elif event is InputEventMouseButton:
			if event.is_pressed():			
				position = event.position
				visible = true				
				knob.pressing = true
			if event.is_released():						
				visible = false	
				knob.pressing = false	
		

func _ready() -> void:
	circle = Sprite2D.new()
	knob = AnalogKnob.new()
	button = Button.new()
	circle.texture = CircleTexture
	knob.texture = KnobTexture
	button.self_modulate = Color.from_hsv(0,0,0,0)	
	add_child(circle)
	add_child(knob)
	add_child(button)		
	knob.deadzone = Deadzone
	knob.maxLength = MaxLenght * scale.x
	
	up_event.action = UpInput
	down_event.action = DownInput
	left_event.action = LeftInput
	right_event.action = RightInput	
	circle.modulate = ControlsColor
	knob.modulate = ControlsColor
	if PositionType == ControlPosition.OnTouch:
		visible = false
		
func _process(delta: float) -> void:
	
	up_event.strength = 0
	up_event.pressed = false
	down_event.strength = 0
	down_event.pressed = false	
	left_event.strength = 0
	left_event.pressed = false	
	right_event.strength = 0
	right_event.pressed = false	
		
	if posVector:
		if posVector.y < 0:
			up_event.strength = posVector.y * -1
			up_event.pressed = true

		if posVector.y > 0:
			down_event.strength = posVector.y
			down_event.pressed = true

		if posVector.x < 0:
			left_event.strength = posVector.x * -1
			left_event.pressed = true

		if posVector.x > 0:
			right_event.strength = posVector.x
			right_event.pressed = true

	Input.parse_input_event(right_event)
	Input.parse_input_event(up_event)
	Input.parse_input_event(down_event)
	Input.parse_input_event(left_event)
