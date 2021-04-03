extends StaticBody2D

export (AudioStreamRandomPitch) var sfxChop
export (AudioStreamRandomPitch) var sfxHit

var maxHP = 1
var hp
var hitCount

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var audioStreamPlayer = $AudioStreamPlayer2D

func _ready():
	hitCount = 0
	if "Tree" in name:
		maxHP = 4
		hp = 4
	else:
		maxHP = 1
		hp= 1
		
func add_hp(to_add: int):
	hp = clamp(to_add + hp, 0, maxHP)
	
func _on_Area2D_area_entered(_area):
	if hp <= 0:
		return
	hp -= 1
	hitCount += 1
	#Var printing for testing purposes
	#print("Hit number: " + str(hitCount))
	#print(name + "current HP: " + str(hp))	
	animationPlayer.play("Hit " + str(hitCount))
	animationPlayer.queue("Idle Lv"+str(hp))
	if hp <= 0:
		hitCount = 0
		#Depending on plant type, we will use a cut animation or another
		if "Bush" in name:
			animationPlayer.play("Grow")
			#If we wanted to have the bush hit animation - removed as it mismatches sound.
			animationPlayer.play("Hit 1")
			animationPlayer.queue("Grow")
			audioStreamPlayer.stream = sfxChop
		else:
			animationPlayer.play("Hit 4")
			animationPlayer.queue("Grow")
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
