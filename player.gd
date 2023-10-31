class_name Player extends CharacterBody2D

signal bullet_shot(bullet_scene, location)
signal player_died()
 
@onready var bullet_marker = $bullet_spawn_marker
@onready var animation = $AnimatedSprite2D

@export var speed = 400
@export var cooldown = false
@export var rate_of_fire = 0.5
var isPlayerAlive = true

var bullet_scene = preload("res://bullet.tscn")

func _process(_delta):
	if Input.is_action_pressed("fire"):
		if !cooldown:
			cooldown = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			cooldown = false
			
	
func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("move_left","move_right"),
	 Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	
	move_and_slide()
	
	if direction.x == -1:
		animation.play("turn")
		animation.flip_h = true

	elif direction.x == 1:
		animation.play("turn")
		animation.flip_h = false

	elif !isPlayerAlive:
		animation.play("die")
	else:
		animation.play("idle")
	
	# limit player position inside game viewport
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)	
		
func shoot(): 
	bullet_shot.emit(bullet_scene, bullet_marker.global_position)

func player_die():
	isPlayerAlive = false
	player_died.emit()
	await get_tree().create_timer(0.5).timeout
	queue_free();

func player_bonus():
	pass
	

	
	
