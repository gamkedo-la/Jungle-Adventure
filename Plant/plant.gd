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


func _on_RenderArea2D_body_entered(body):
	if body.name == "Player" and body.position.y < self.position.y:
		animationPlayer.play("Transparent")


func _on_RenderArea2D_body_exited(body):
	if body.name == "Player" and body.position.y < self.position.y:
		animationPlayer.play("Opaque")
