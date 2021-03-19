extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var bubbles =  $ClamBubbles
func _ready():
	animationPlayer.play("onc")
	

