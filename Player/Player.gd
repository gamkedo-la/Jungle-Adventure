extends KinematicBody2D

enum {
	MOVE,
	STRIKE
}

export var ACCELERATION = 500
export var MAX_SPEED = 250
export var FRICTION = 1000

var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _process(delta):
	Global.player_position = position
	match state:
		MOVE:
			state_move(delta)
		STRIKE:
			state_strike(delta)


func state_move(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if !input_vector.is_equal_approx(Vector2.ZERO):
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Strike/blend_position", input_vector)
		animationState.travel("Walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
	if velocity.is_equal_approx(Vector2.ZERO):	
		animationState.travel("Idle")
	if Input.is_action_just_pressed("action"):
		state = STRIKE
	
	velocity = move_and_slide(velocity)
	
	
func state_strike(delta):
	animationState.travel("Strike")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	

func set_state_to_move():
	state = MOVE
	
	
	
	
	
	
	
