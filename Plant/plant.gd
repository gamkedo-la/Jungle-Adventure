extends StaticBody2D

export (int) var maxHP = 1
export (AudioStreamRandomPitch) var sfxChop
export (AudioStreamRandomPitch) var sfxHit

var hp = maxHP

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var audioStreamPlayer = $AudioStreamPlayer2D

func _ready():
	hp = maxHP
	
func add_hp(to_add: int):
	hp = clamp(to_add + hp, 0, maxHP)

func _on_Area2D_area_entered(_area):
	if hp <= 0:
		return
	hp -= 1
	if hp <= 0:
		animationPlayer.stop()
		animationPlayer.play("Grow")
		audioStreamPlayer.stream = sfxChop
	else :
		audioStreamPlayer.stream = sfxHit
	audioStreamPlayer.play()


func _on_RenderArea2D_body_entered(body):
	if body.name == "Player":
		animationPlayer.play("Transparent")


func _on_RenderArea2D_body_exited(body):
	if body.name == "Player":
		animationPlayer.play("Opaque")
