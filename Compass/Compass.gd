extends Container

# export(type, min, max, step)
# Class members can be exported, this means their value gets saved along with the resource (such as the scene) they're attached to. 
# They will also be available for editing in the property editor.
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_exports.html
export(Vector2) var NorthPosition = Vector2.ZERO  # The compass points at this position aka North
export var PointAtMouse = false # Mainly for debugging

# onready var my_label = get_node("MyLabel") 
# A scene's subnodes can't be accessed until _ready() is entered. The onready keyword, defers variable initialization until _ready() is called.
# https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#onready-keyword
onready var Needle := get_node("Needle")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pointAt = NorthPosition
	if(PointAtMouse):
		pointAt = get_global_mouse_position();
	
	# Do some math to recalculate the Pointer orientation
	#Needle.rotation = ( pointAt - Needle.position).angle() # Might need to add + PI / 2 here ??
	Needle.look_at(pointAt);
	
# Not sure what I've done wrong declaring these param
#func SetNorthPosition(Position2D northPosition):
func SetNorthPosition(northPosition):
	NorthPosition = northPosition
