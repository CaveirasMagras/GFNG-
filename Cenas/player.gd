extends CharacterBody2D

var Shooted = false

var Gun = false

var speed = 200
@onready var Shot = load("res://Cenas/shot.tscn")
@onready var animation = $AnimationPlayer
@onready var ParticlesDie = load("res://Cenas/player_die_particle.tscn")

func _ready():
	pass

func _process(delta):
	
	
	
	var Diry = $"../AndroidController/JoyStick".get_velo().y
	if Diry:
		velocity.y = speed * Diry
	else:
		velocity.y = 0
		
	var Dirx = $"../AndroidController/JoyStick".get_velo().x
	if Dirx:
		velocity.x = speed * Dirx
	else :
		velocity.x = 0

	if Dirx and Diry:
		velocity.normalized()


	if Input.is_action_just_pressed("SHOOT") and Shooted == false and Gun:
		Shoot()

	if !Dirx and Diry > 0:
		animation.play("Walk1")
	if  !Dirx and Diry < 0:
		animation.play("Walk5")
	if Dirx > 0 and !Diry:
		animation.play("Walk3")
	if Dirx < 0 and !Diry:
		animation.play("Walk 7")

	if Dirx < 0 and Diry < 0:
		animation.play("Walk6")
	if Dirx > 0 and Diry > 0:
		animation.play("Walk2")
	if Dirx < 0 and Diry > 0:
		animation.play("Walk8")
	if Dirx > 0 and Diry < 0:
		animation.play("Walk4")
	
	if !Dirx and !Diry:
		animation.play("Idle")

	move_and_slide()
	pass
	

func Die():
	var particlesdie = ParticlesDie.instantiate()
	get_tree().root.add_child(particlesdie)
	GlobalVar.PlayerAlive = false
	particlesdie.position = global_position
	particlesdie.emitting = true
	queue_free()
	pass


func Shoot():
	Shooted = true
	var shot = Shot.instantiate()
	get_tree().root.add_child(shot)
	shot.position = global_position
	shot.Angle = get_global_mouse_position() - global_position
	await get_tree().create_timer(0.2).timeout
	Shooted = false
	pass
