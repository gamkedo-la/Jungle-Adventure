extends StaticBody2D

export (int) var maxHP = 1

var hp = maxHP

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

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
