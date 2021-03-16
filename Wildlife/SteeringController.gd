extends Node2D

# Let's do something boids-like http://www.kfish.org/boids/pseudocode.html
# We aren't using a singleton to orchestrate though, let's just have each animal make its own calculations, there should never be that many
const NeighorSearchShape: CircleShape2D = preload("res://Wildlife/AnimalSteeringNeighborSearch.tres")
var neighbor_search_radius := 200 setget set_radius

var center_of_mass_strength = 0.0001

var keep_distance_radius = 50.0
var match_velocity_strength = 0.05
var follow_goal_strength = 0.25

var mask := 0 setget set_mask
var last_seen = []


func _ready():
	NeighorSearchShape.radius = neighbor_search_radius

func _draw():
	if Utils.DRAW_DEBUG:
		draw_circle(Vector2.ZERO, keep_distance_radius, Color(0, 0, 0, 0.25))
		for neighbor in last_seen:
			draw_line(Vector2.ZERO, to_local(neighbor.global_position), Color.red)

func set_mask(value: int) -> void:
	mask = value
	
func set_radius(value: int) -> void:
	neighbor_search_radius = value
	NeighorSearchShape.radius = neighbor_search_radius

func get_target_velocity(current_velocity: Vector2, goal) -> Vector2:
	last_seen = []
	update()
	var collisions = Utils.shape_cast_get_result(NeighorSearchShape, get_parent().transform, self.mask, [get_parent()])
	if  collisions == null || collisions.size() == 0:
		return current_velocity
	
	
	
	var center_of_mass = Vector2.ZERO
	var keep_distance = Vector2.ZERO
	var match_velocity = Vector2.ZERO
	var follow_goal = Vector2.ZERO
	var flee_direction = Vector2.ZERO
	
	var neigbor_count = 0
	for collision in collisions:
		var neighbor = collision.collider
		# Don't want to mess with layers, collisions, etc.
		if neighbor != null and neighbor.name.find("Bush") != -1:
			continue;
		
		last_seen.append(neighbor)
		# rule 1
		if neighbor is Animal:
			neigbor_count += 1
			center_of_mass += neighbor.global_position
			
		# rule 2
		if neighbor.global_position.distance_to(get_parent().global_position) < keep_distance_radius:
			keep_distance = keep_distance - (neighbor.global_position  - get_parent().global_position)
			
		# rule 3
		if neighbor is Animal:
			match_velocity += neighbor.velocity
		
		if neighbor.name.find("Player") != -1:
			if neighbor.global_position.distance_to(get_parent().global_position) < (keep_distance_radius * 3.0):
				flee_direction = - (neighbor.global_position - get_parent().global_position)
		
	
	# rule 5
	if goal != null:
		follow_goal = (goal - get_parent().global_position).normalized() * follow_goal_strength
	
	
	# rule 5
#	if flee != null:

	
	if neigbor_count > 0:
		center_of_mass /= float(neigbor_count)
		match_velocity /= float(neigbor_count)
	
	center_of_mass = (center_of_mass - get_parent().global_position) * center_of_mass_strength
	match_velocity = (match_velocity - get_parent().velocity) * match_velocity_strength
	keep_distance *= 0.01
	
	return current_velocity + center_of_mass + keep_distance + match_velocity + follow_goal + flee_direction
