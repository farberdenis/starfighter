class_name Enemy extends Area2D
# signal for world script to know if enemy is killed
signal killed(points)

@onready var animation = $AnimatedSprite2D
@onready var collision = %CollisionShape2D

@export var speed = 250
@export var enemy_hp = 2
@export var points = 100

func _physics_process(delta):
	global_position.y += speed * delta

func enemy_die():
	animation.play("die")
	collision.set_deferred("disabled", true)

	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body):
	body.player_die()
 
func take_damage(amount):
	enemy_hp -= amount
	if enemy_hp <= 0:
		killed.emit(points)
		enemy_die()
