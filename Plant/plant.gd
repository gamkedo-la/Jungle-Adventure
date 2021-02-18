extends StaticBody2D

export (int) var maxHP = 1

var hp = maxHP

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite

func _ready():
	hp = maxHP

func _on_Area2D_area_entered(_area):
	hp -= 1
	if hp <= 0:
		sprite.frame = 1
		collisionShape.set_deferred("disabled", true)
