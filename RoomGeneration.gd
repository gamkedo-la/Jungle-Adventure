extends Node2D

enum { WEST, NORTH, EAST, SOUTH }

const DIRECTION = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
const CELL_SIZE = 64
const ROOM_WIDTH = 18
const ROOM_HEIGHT = 12
const ROOM_WIDTH_PX = ROOM_WIDTH*CELL_SIZE
const ROOM_HEIGHT_PX = ROOM_HEIGHT*CELL_SIZE
const EXPLORE_SIZE = 1

var Rooms : PackedScene = preload("res://Rooms.tscn")

var _rooms: Node2D = null
var _current_rooms := {}
var _room_options := []
var _room_with_player = Vector2.ZERO
var _rng := RandomNumberGenerator.new()
var forget_size = 2
var generator_ready = false

onready var branch_for_members = $BranchForMembers
onready var branch_for_rooms = $BranchForRooms

func _ready():
	_rng.randomize()
	_rooms = Rooms.instance()
	_scan_for_rooms()
	generator_ready = true
	_update_map()


func player_here(player_position:Vector2):
	_room_with_player = player_position
	if generator_ready:
		_update_map()


func _update_map():
	for old_room in _current_rooms.values():
		if old_room.room_position.x < _room_with_player.x-forget_size or old_room.room_position.x > _room_with_player.x+forget_size or old_room.room_position.y < _room_with_player.y-forget_size or old_room.room_position.y > _room_with_player.y+forget_size:
			if not old_room.permanent:
				_current_rooms.erase(old_room.room_position.round())
				old_room.remove_room()
	for x in range(_room_with_player.x-EXPLORE_SIZE, _room_with_player.x+EXPLORE_SIZE+1):
		for y in range(_room_with_player.y-EXPLORE_SIZE, _room_with_player.y+EXPLORE_SIZE+1):
			if not _current_rooms.has(Vector2(x, y)):
				_add_room(Vector2(x, y), _find_room(Vector2(x, y)))
				yield(get_tree(), "physics_frame")


func _find_room(new_position: Vector2) -> Node:
	#Start with an empty array
	_room_options.clear()
	#Fill the array with rooms
	for object in _rooms.get_children():
		_room_options.append(object)
	#Loop through all 4 directions
	for dir in range(0, 4):
		#Check if there is a room at this location
		if _current_rooms.has(new_position + DIRECTION[dir].round()):
			#Assigns for the inverse direction
			var check_dir = (dir + 2) % 4
			#Grabs a referance for the room in that relative direction
			var current_room = _current_rooms[new_position + DIRECTION[dir].round()]
			
			#Scan through all rooms remaining in the array
			for i in range(_room_options.size() -1, -1, -1):
				#If the room doesn't contain a matching node...
				if not _room_options[i].available_nodes[dir] == current_room.available_nodes[check_dir]:
					#...Remove it from the array
					_room_options.erase(_room_options[i])
	#Return a random room from whats left in the array
	return _room_options[_rng.randi_range(0, _room_options.size() - 1)]


func _add_room(room_position: Vector2, to_copy:Node):
	var world_offset := _grid_to_world(room_position.round())
	var new_room = to_copy.duplicate()
	new_room.position += world_offset
	new_room.room_position = room_position
	new_room.connect("player_present", self, "player_here")
	
	_current_rooms[room_position.round()] = new_room
	branch_for_rooms.call_deferred("add_child", new_room)
	new_room.call_deferred("add_room", _rng, branch_for_members)


func _scan_for_rooms():
	if branch_for_rooms.get_child_count() > 0:
		for child in branch_for_rooms.get_children():
			var new_position = Vector2(floor(child.position.x/ROOM_WIDTH), ceil(child.position.y/ROOM_HEIGHT))
			child.room_position = new_position
			_current_rooms[new_position] = child
			child.connect("player_present", self, "player_here")


func _grid_to_world(vector: Vector2) -> Vector2:
	return Vector2(vector.x * ROOM_WIDTH_PX, vector.y * ROOM_HEIGHT_PX)
