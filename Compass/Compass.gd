extends CenterContainer

# export(type, min, max, step) https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_exports.html
# These are complaining about not being a resource type ??
#export(AnimatedSprite) var Pointer;  # The part that points "north"
#export(Position2D) var NorthPosition = ; # The compass points at this position aka North
var NorthPosition:Position2D; # The compass points at this position aka North

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Do some math to recalculate the Pointer orientation
	pass
	
# Not sure what I've done wrong declaring these param
#func SetNorthPosition(Position2D northPosition):
func SetNorthPosition(northPosition):
	NorthPosition = northPosition
