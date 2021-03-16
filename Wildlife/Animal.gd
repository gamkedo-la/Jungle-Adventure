extends Area2D
class_name Animal

enum {
	WANDER,
	FLEE,
	GOAL,
}

const animation_length_seconds = 0.6

onready var steering_controller = $SteeringController
onready var animation_tree = $AnimationTree

var goal_distance_threshold := 200.0

var MAX_SPEED = 4.0
var MIN_SPEED = 3.0

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var on_screen = false
var should_free = false

var room_spawn = Vector2.ZERO

var state = WANDER
var timer_length = 15

var set_animation_player_position = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized() * MAX_SPEED
	# Player, World, other animals
	var mask_bit = 2 | 16 | 32
	steering_controller.set_mask(mask_bit)

	$WanderTimer.start(timer_length)
	

func _physics_process(_delta):
	if $AnimationPlayer.is_playing() and !set_animation_player_position:
		set_animation_player_position = true
		$AnimationPlayer.seek(randf() * animation_length_seconds)
	
	var goal = room_spawn if state == GOAL else null
	
	velocity = steering_controller.get_target_velocity(velocity, goal)
	if abs(velocity.length()) < MIN_SPEED:
		velocity = velocity.normalized() * MIN_SPEED
	elif abs(velocity.length()) > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	
	animation_tree.set("parameters/blend_position", velocity.normalized())
	
	position += velocity
	
	if state == GOAL && room_spawn.distance_to(global_position) <= goal_distance_threshold:
		state = WANDER
		$WanderTimer.start()
	
	update()
	

func _draw():
	if Utils.DRAW_DEBUG:
		draw_line(Vector2.ZERO, (velocity * 20.0), Color.green)

func init(spawn_point, wander_timer_start):
	room_spawn = spawn_point
	timer_length = wander_timer_start

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

func _on_WanderTimer_timeout():
	assert(state == WANDER)
	state = GOAL
