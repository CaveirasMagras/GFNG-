extends CharacterBody2D


@onready var ParticlesDie = load("res://Cenas/player_die_particle.tscn")
@onready var SoundDie = load("res://Cenas/explosion_sound.tscn")
@export var Direction = Vector2(1,0)
@export var Perseguidor = true
@export var Speed = 200




@onready var Player = get_tree().get_first_node_in_group("Player")
var PlayerPosition

func _ready():
	pass

func _process(delta):
	move_and_slide()
	if Perseguidor:
		if GlobalVar.PlayerAlive == true:
			var PlayerPosition = (Player.global_position - global_position).normalized()
			if Player.global_position.x > global_position.x:
				$Sprite2D.scale.x = abs($Sprite2D.scale.x)
			if Player.global_position.x < global_position.x:
				$Sprite2D.scale.x = abs($Sprite2D.scale.x) * -1
			#look_at(Player.global_position)
			velocity = Vector2(PlayerPosition.x * Speed, PlayerPosition.y * Speed)
		else:
			Die()
			pass


	if !Perseguidor:
		velocity = Vector2(Direction.x * Speed,Direction.y * Speed)
		if Direction.x == 1:
			$Sprite2D.scale.x = abs($Sprite2D.scale.x)
		if Direction.x == -1:
			$Sprite2D.scale.x = abs($Sprite2D.scale.x) * -1
		#if Direction.y == 1:
			#$Sprite2D.rotation = deg_to_rad(90)
		#if Direction.y == -1:
			#$Sprite2D.rotation = deg_to_rad(270)
		
		pass
	pass

func Die():
	var particlesdie = ParticlesDie.instantiate()
	get_tree().root.add_child(particlesdie)
	particlesdie.position = global_position
	particlesdie.emitting = true
	var sounddie = SoundDie.instantiate()
	get_tree().root.add_child(sounddie)
	sounddie.position = global_position
	
	queue_free()
	pass
	
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Tiro"):
		body.queue_free()
		Die()
	if body.is_in_group("Player"):
		body.Die()
	pass # Replace with function body.
