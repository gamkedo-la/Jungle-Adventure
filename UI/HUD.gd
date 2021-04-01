extends VBoxContainer

onready var vert_margin = $VSpacer
onready var vert_margin_mid = $VSpacer_MidScreen
onready var compass_right_margin = $CompassCont/HSpacer
onready var compass_container = $CompassCont
onready var compass = $CompassCont/Compass
onready var landmark_cont = $LandmarkContainer

onready var landmark_icons = landmark_cont.get_children()
var test_lm = 0
onready var dimensions = get_viewport_rect()
# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_margins()
	#compass_container.rect_min_size.y = compass.
	#compass.rect_position.x = dimensions.position.x



func refresh_margins():
	# HUD Box Positionining
	rect_position.x = 0
	rect_position.y = dimensions.position.y
	rect_min_size = dimensions.size * .90
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_bottom = 0.5
	anchor_top = 0.5
	
	# HUD Box Vertical Spacers	
	vert_margin.rect_min_size.y = dimensions.size.y * .1
	#Compass Box Horizontal Spacer
	compass_right_margin.rect_size.x = dimensions.size.x * .05
	
	# Compass Position	
	compass_container.rect_min_size.x = dimensions.size.x * .95 
	compass.rect_position.x = compass_container.rect_size.x * .7
	
	#Mid Screen Spacer
	vert_margin_mid.rect_min_size.y = dimensions.size.y * .50
	vert_margin_mid.rect_min_size.x = dimensions.size.x * .50
	
	landmark_cont.rect_min_size.x = dimensions.size.x * .50
	landmark_cont.alignment = BoxContainer.ALIGN_CENTER
	

func record_landmark(index):
	var landmark_icon = null
	index -= 1
	if index <= landmark_cont.get_child_count():
		landmark_icon = landmark_cont.get_child(index)
	if landmark_icon:
		landmark_icon.visible = true

func _on_HUD_resized():
	if dimensions:
		refresh_margins()

