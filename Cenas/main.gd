extends Node2D

var Enemy = load("res://Cenas/enemy.tscn")

var Started = false

var stageTutorial = true
var stage1 = false
var stage2 = false
var stage3 = false


var rng = RandomNumberGenerator.new()

#region TimerVar

var TotalSeconds = 0

var TimeDif = 1

var SecondsU = 0
var MinutesU = 0
var SecondsD = 0
var MinutesD = 0
#endregion

func _ready():
	if GlobalVar.stage3 == true:
		$RichTextLabel.visible = false
		$AreaTutorial.queue_free()
		$"Enemy Stage1".queue_free()
		$FirstEnemy.queue_free()
		$Timer.start()
		$TimerText.visible = true
		stage3 = true
		SecondRound()
	
	pass


func _process(delta):
	
	if GlobalVar.PlayerAlive == false:
		$AudioStreamPlayer2D.stop()
	
	if TotalSeconds == 30:
		TimeDif = 0.8
	if TotalSeconds == 60:
		TimeDif = 0.6
	if TotalSeconds == 90:
		TimeDif = 0.4
	if TotalSeconds == 120:
		TimeDif = 0.2
	if TotalSeconds == 150:
		TimeDif = 0.1

#region Timer

	if SecondsU == 10:
		SecondsD += 1
		SecondsU = 0
	if SecondsD == 6:
		MinutesU += 1
		SecondsD = 0
	if MinutesU == 10:
		MinutesD += 1
		MinutesU = 0
	$TimerText.text = (str(MinutesD)+str(MinutesU) + ":" +str(SecondsD)+ str(SecondsU))
	#endregion
	
	if GlobalVar.PlayerAlive == false and !stage3:
		$GameOverText.visible = true
		$AndroidController/RestartButton.visible = true
		if Input.is_action_just_pressed("ui_accept"):
			GlobalVar.PlayerAlive = true
			get_tree().change_scene_to_file("res://Cenas/main.tscn")
	
	if !GlobalVar.PlayerAlive and stage3:
		$GameOverText.modulate = Color.YELLOW
		$GameOverText.text = "[center]Obrigado por jogar!"
		$GameOverText.visible = true
		$AndroidController/RestartButton.visible = true
		if Input.is_action_just_pressed("ui_accept"):
			GlobalVar.PlayerAlive = true
			get_tree().change_scene_to_file("res://Cenas/main.tscn")
	
	pass


func resetTimer():
	SecondsU = 0
	SecondsD = 0
	MinutesU = 0
	MinutesD = 0
	pass

func FirstRound():
	while stage2:
		var Direction = rng.randi_range(1,4)
		var enemy = Enemy.instantiate()
		enemy.Perseguidor = false
		add_child(enemy)
		if Direction == 1:
			enemy.position = Vector2(-20,rng.randi_range(0,648))
			enemy.Direction = Vector2(1,0)
		if Direction == 2:
			enemy.position = Vector2(1170,rng.randi_range(0,648))
			enemy.Direction = Vector2(-1,0)
		if Direction == 3:
			enemy.position = Vector2(rng.randi_range(0,1152),-20)
			enemy.Direction = Vector2(0,1)
		if Direction == 4:
			enemy.position = Vector2(rng.randi_range(0,1152),655)
			enemy.Direction = Vector2(0,-1)
		await get_tree().create_timer(TimeDif).timeout
	pass

func SecondRound():
	while stage3:
		var Direction = rng.randi_range(1,4)
		var enemy = Enemy.instantiate()
		enemy.Perseguidor = false
		add_child(enemy)
		if Direction == 1:
			enemy.position = Vector2(-20,rng.randi_range(0,648))
			enemy.Direction = Vector2(1,0)
		if Direction == 2:
			enemy.position = Vector2(1170,rng.randi_range(0,648))
			enemy.Direction = Vector2(-1,0)
		if Direction == 3:
			enemy.position = Vector2(rng.randi_range(0,1152),-20)
			enemy.Direction = Vector2(0,1)
		if Direction == 4:
			enemy.position = Vector2(rng.randi_range(0,1152),655)
			enemy.Direction = Vector2(0,-1)
		await get_tree().create_timer(TimeDif).timeout
	pass


func _on_timer_timeout():
	if GlobalVar.PlayerAlive == true:
		SecondsU += 1
		TotalSeconds += 1
		$Timer.start()
	pass # Replace with function body.


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.playing = true
	pass # Replace with function body.


func _on_area_tutorial_body_entered(body: Node2D) -> void:
	$AreaTutorial.queue_free()
	stageTutorial = false
	stage1 = true
	$RichTextLabel.modulate = Color.RED
	$RichTextLabel.text = "[center]Cuidado agora! Desvie do morcego![/center]"
	$"Enemy Stage1".Speed = 200
	pass # Replace with function body.


func _on_first_enemy_body_entered(body: Node2D) -> void:
	$FirstEnemy.queue_free()
	$"Enemy Stage1".queue_free()
	$RichTextLabel.modulate = Color.WHITE
	$RichTextLabel.text = "[center]Ótimo! continue desviando"
	stage1 = false
	stage2 = true
	$TimerStage2.start()
	FirstRound()
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	pass # Replace with function body.


func _on_timer_stage_2_timeout() -> void:
	stage2 = false
	$RichTextLabel.modulate = Color.YELLOW
	$RichTextLabel.text = "[center]Parabéns! Você dominou os controles basicos!"
	await get_tree().create_timer(5).timeout
	$RichTextLabel.modulate = Color.WHITE
	$RichTextLabel.text = "[center]Quanto tempo você consegue sobreviver?."
	await get_tree().create_timer(5).timeout
	GlobalVar.stage3 = true
	stage3 = true
	SecondRound()
	$Timer.start()
	$TimerText.visible = true
	pass # Replace with function body.
