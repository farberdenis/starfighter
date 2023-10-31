extends Area2D

signal bonus_picked()

var speed = 450

func _physics_process(delta):
	global_position.y += speed * delta
	
# player enters bonus item and fires fuction bonus_picked
func _on_body_entered(body):
	if body.name == 'Player':
		bonus_picked.emit()
		queue_free()

	
