extends Area2D

signal player_present(player_position)

enum { WEST, NORTH, EAST, SOUTH }

const DIRECTION = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
const TREE_FREQUENCY = 50
const CELL_SIZE = 64
const ROOM_WIDTH = 18
const ROOM_HEIGHT = 12
const ROOM_WIDTH_PX = ROOM_WIDTH*CELL_SIZE
const ROOM_HEIGHT_PX = ROOM_HEIGHT*CELL_SIZE

export var permanent = false;
export var available_nodes = {
	WEST: 0,
	NORTH: 0,
	EAST: 0,
	SOUTH: 0
}
export (Array, PackedScene) var trees

var room_position = Vector2.ZERO
var _members = {}

onready var tileMap = $TileMap


func add_room(rng, branch_for_members):
	for _i in range(0, TREE_FREQUENCY):
		var x = rng.randi_range(0, ROOM_WIDTH)
		var y = rng.randi_range(0, ROOM_HEIGHT)
		#if tileMap.get_cellv(Vector2(x, y)) == 1 and not _members.has(Vector2(x, y).round()):
		if not _members.has(Vector2(x, y).round()) and trees.size() > 0:
			var new_tree = trees[rng.randi_range(0, trees.size()-1)].instance()
			_members[Vector2(x, y).round()] = new_tree
			new_tree.position += position + Vector2(x, y) * CELL_SIZE + (Vector2(CELL_SIZE, CELL_SIZE) * rng.randf())
			branch_for_members.call_deferred("add_child", new_tree)
			yield(get_tree(), "physics_frame")


func remove_room():
	for i in _members:
		_members[i].queue_free()
		yield(get_tree(), "physics_frame")
	_members.clear()
	queue_free()


func update_Room():
	pass


func _on_Room_body_entered(_body):
	emit_signal("player_present", room_position)
