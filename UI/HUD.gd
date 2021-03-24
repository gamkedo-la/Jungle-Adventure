extends VBoxContainer

onready var vert_margin = $VSpacer
onready var vert_margin_mid = $VSpacer_MidScreen
onready var compass_right_margin = $CompassCont/HSpacer
onready var compass_container = $CompassCont
onready var compass = $CompassCont/Compass
onready var landmark_cont = $LandmarkContainer

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
	
	# HUD Box Vertical Spacers	
	vert_margin.rect_min_size.y = dimensions.size.y * .1
	#Compass Box Horizontal Spacer
	compass_right_margin.rect_size.x = dimensions.size.x * .05
	
	# Compass Position	
	compass_container.rect_min_size.x = dimensions.size.x * .95 
	compass.rect_position.x = compass_container.rect_size.x * .7
	
	#Mid Screen Spacer
	vert_margin_mid.rect_min_size.y = dimensions.size.y * .30
	vert_margin_mid.rect_min_size.x = dimensions.size.x * .50
	
	landmark_cont.rect_min_size.x = dimensions.size.x * .50
	landmark_cont.alignment = BoxContainer.ALIGN_CENTER
	



func _on_HUD_resized():
	if dimensions:
		refresh_margins()
