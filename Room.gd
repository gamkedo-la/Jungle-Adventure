extends Area2D

signal player_present(player_position)

enum { WEST, NORTH, EAST, SOUTH }

const DIRECTION = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
const TREE_FREQUENCY = 50
const MAX_ANIMALS := 5
const ANIMAL_SPAWN_CHANCE := 0.5
const ANIMAL_SPAWN_RADIUS := 100.0
const CELL_SIZE = 64
const ROOM_WIDTH = 18
const ROOM_HEIGHT = 12
const ROOM_WIDTH_PX = ROOM_WIDTH*CELL_SIZE
const ROOM_HEIGHT_PX = ROOM_HEIGHT*CELL_SIZE

const AnimalScene: PackedScene = preload("res://Wildlife/Animal.tscn")

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
var _animal_members = []

onready var tileMap = $TileMap
onready var forMemberBranch = $ForMemberBranch


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
	
	
	var animal_spawn_area = Vector2(rng.randi_range(0, ROOM_WIDTH), rng.randi_range(0, ROOM_HEIGHT))
	var animal_wander_time = randi() % 15 + 5
	for _i in range(0, MAX_ANIMALS):
		if randf() > ANIMAL_SPAWN_CHANCE:
			var animal = AnimalScene.instance()
			animal.init(global_position + animal_spawn_area, animal_wander_time)
			_animal_members.append(animal)
			var random_offset = Vector2.RIGHT.rotated(deg2rad(randf() * 360.0)).normalized() * (randf() * ANIMAL_SPAWN_RADIUS)
			animal.position = position + animal_spawn_area + random_offset
			branch_for_members.call_deferred("add_child", animal)


func find_this_room(branch_for_members):
	for new_member in forMemberBranch.get_children():
		forMemberBranch.remove_child(new_member)
		branch_for_members.add_child(new_member)
		var x = new_member.position.x/CELL_SIZE
		var y = new_member.position.y/CELL_SIZE
		_members[Vector2(x, y).round()] = new_member
		new_member.position += position
	forMemberBranch.queue_free()


func remove_room():
	for i in _members:
		_members[i].queue_free()
		yield(get_tree(), "physics_frame")
	_members.clear()

	for animal in _animal_members:
		animal.room_removed()
	_animal_members.clear()

	queue_free()


func update_Room():
	pass


func _on_Room_body_entered(_body):
	emit_signal("player_present", room_position)
