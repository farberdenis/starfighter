extends Node2D

@onready var player = $Player
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var bouns_container = $BonusContainer
@onready var hud = $UI_layer/HUD
@onready var gameover = $UI_layer/GameOverScreen
@onready var reset_hi_score = $UI_layer/GameOverScreen/VBoxContainer/reset_hi_score
@onready var pause_screen = $UI_layer/PauseScreen

@onready var bullet_sound = $SFX/bullet
@onready var enemy_hit_sound = $SFX/enemy_explode
@onready var player_explode_sound = $SFX/player_explode
@onready var eva_endgame_sound = $SFX/eva_sound
@onready var bonus_pickup_sound = $SFX/bonus

@export var enemy_scenes : Array[PackedScene] = []
var bonus_scene = preload("res://bonus_item.tscn")

var score = 0:
	set(value):
		score = value
		hud.score = score

var high_score

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	
	else:
		high_score = 0
		save_game()
	
	hud.score = 0
	player.bullet_shot.connect(_on_player_bullet_shot)

func _process(_delta):	
	if Input.is_action_just_pressed("menu") && gameover.visible == false:
		get_tree().paused = true
		pause_screen.show()
		
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	
func _on_player_bullet_shot(bullet_scene, location):
	bullet_sound.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	add_child(bullet)

func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(-270, 270), -20)
	enemy.killed.connect(_on_enemy_killed)
	enemy_container.add_child(enemy)
	
	# icr spawn speed based on score
	if score >= 1000:
		timer.wait_time = 0.5
		$StartsVFX.color = Color.GREEN
	if score >= 3000:
		$StartsVFX.color = Color.RED

func _on_enemy_killed(points):
	enemy_hit_sound.play()
	score += points
	if score > high_score:
		high_score = score

func _on_player_player_died():
	player_explode_sound.play()
	gameover.set_score(score)
	gameover.set_high_score(high_score)
	save_game()
	# show gameover after 1 sec
	await get_tree().create_timer(1).timeout
	eva_endgame_sound.play()
	gameover.visible = true

func _on_pause_screen_unpause_game():
	get_tree().paused = false
	pause_screen.hide()

func _on_game_over_screen_reset_score():
	DirAccess.remove_absolute("user://save.data")
	high_score = 0
	gameover.set_high_score(high_score)

func _on_bonus_spawn_timer_timeout():
	var bonus_item = bonus_scene.instantiate()
	# connect bonus_picked from bonus scene
	bonus_item.bonus_picked.connect(_on_player_bonus_picked)

	if bonus_item:
		bonus_item.global_position = Vector2(randf_range(-270, 270), -20)
		bouns_container.add_child(bonus_item)

func _on_player_bonus_picked():
	bonus_pickup_sound.play()
	player.rate_of_fire = 0.1
	await get_tree().create_timer(5).timeout
	player.rate_of_fire = 0.5


