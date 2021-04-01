extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			main_menu.visible = true
		else:
			get_tree().paused = false
			main_menu.visible = false


