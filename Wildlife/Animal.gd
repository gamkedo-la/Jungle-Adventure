extends Area2D
class_name Animal

enum {
	IDLE,
	WANDER,
	FLEE
}

onready var steering_controller = $SteeringController
onready var animation_player = $AnimationPlayer

var MAX_SPEED = 2.5
var MIN_SPEED = 1.0

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var on_screen = false
var should_free = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized() * MAX_SPEED
	# World, other fish
	var mask_bit = 1 | (1 << 4)
	steering_controller.set_mask(mask_bit)

func _process(delta):
	velocity = steering_controller.get_target_velocity(velocity)
	if abs(velocity.length()) < MIN_SPEED:
		velocity = velocity.normalized() * MIN_SPEED
	elif abs(velocity.length()) > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	position += velocity
	update()
	

func _draw():
	if Utils.DRAW_DEBUG:
		draw_line(Vector2.ZERO, (velocity * 10.0), Color.green)

func room_removed():
	if on_screen == false:
		queue_free()
	else:
		should_free = true


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
	if should_free:
		queue_free()