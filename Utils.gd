extends Node

const DRAW_DEBUG := false

# Strict typing in the Utils class, as it's shared functionality that we should establish strict api's for

func _construct_query_params(shape: Shape2D, transform: Transform2D, mask: int = 1, exclude: Array = []) -> Physics2DShapeQueryParameters:
	var query := Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.set_shape(shape)
	query.set_transform(transform)
	query.exclude = exclude
	query.collision_layer = mask
	return query
	
# Cast the shape at the origin of transform, detecting collisions based on mask.
# Return true if hit detected, false otherwise
func shape_cast_hit(shape: Shape2D, transform: Transform2D, mask: int = 1) -> bool:
	var shape_result := shape_cast_get_result(shape, transform, mask)
	return shape_result != null && shape_result.size() != 0

# Cast the shape at the origin of transform, detecting collisions based on mask, excluding some objects. 
# Returns an array of dictionaries containing collision data
func shape_cast_get_result(shape: Shape2D, transform: Transform2D, mask: int = 1, exclude: Array = []) -> Array:
	var space_state:Physics2DDirectSpaceState = get_tree().current_scene.get_world_2d().direct_space_state
	var query := _construct_query_params(shape, transform, mask, exclude)
	var shape_result := space_state.intersect_shape(query)
	return shape_result
