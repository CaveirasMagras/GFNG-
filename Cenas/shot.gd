extends CharacterBody2D

var Speed = 500
var Angle = Vector2(0,0)

func _ready():
	await get_tree().create_timer(10).timeout
	queue_free()
	pass


func _process(delta):
	velocity = Vector2(Angle.normalized().x * Speed, Angle.normalized().y * Speed)
	
	move_and_slide()
	pass
