extends Node

export (Array, Vector2) var mix_at_distance

var leaving: bool = false
var fade_speed = 12
var target_explore_db = 0
var target_newroom_db = -40
var target_found_db = -40
var last_landmark = Vector2.INF
var room_with_player = Vector2.ZERO
var current_landmark = Vector2.INF

onready var Explore = $Explore
onready var NewRoom = $NewRoom
onready var Found = $Found

func _process(delta):
	room_with_player = Global.room_with_player
	current_landmark = Global.current_landmark
	if leaving:
		if Global.room_with_player != last_landmark:
			leaving = false
	else:
		if Global.current_landmark != last_landmark:
			leaving = true
			last_landmark = Global.current_landmark
	
	_Set_Targets()
	_Set_Levels(delta)


func _Set_Levels(delta):
	var fade_this_frame = fade_speed * delta
	
	if Explore.volume_db < target_explore_db - fade_this_frame:
		Explore.volume_db += fade_this_frame
	if Explore.volume_db > target_explore_db + fade_this_frame:
		Explore.volume_db -= fade_this_frame
	
	if NewRoom.volume_db < target_newroom_db - fade_this_frame:
		NewRoom.volume_db += fade_this_frame
	if NewRoom.volume_db > target_newroom_db + fade_this_frame:
		NewRoom.volume_db -= fade_this_frame
	
	if Found.volume_db < target_found_db - fade_this_frame:
		Found.volume_db += fade_this_frame
	if Found.volume_db > target_found_db + fade_this_frame:
		Found.volume_db -= fade_this_frame


func _Set_Targets():
	var distance = Global.room_with_player.distance_squared_to(Global.current_landmark)
	
	for i in range(mix_at_distance.size()):
		if distance > i:
				target_explore_db = mix_at_distance[i].x
				target_newroom_db = mix_at_distance[i].y
	
	if leaving:
		target_explore_db = -40
		target_newroom_db = -40
		target_found_db = 0
	else:
		target_found_db = -40












