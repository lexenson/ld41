extends Area2D

export (int) var speed = 300
var velocity = Vector2()

func control(delta):
	velocity = Vector2()
	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite.animation = 'walk'
		velocity = Vector2(-1,0) * speed
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite.animation = 'walk'
		velocity = Vector2(1,0) * speed
		$AnimatedSprite.flip_h = false		
	else:
		$AnimatedSprite.animation = 'idle'
		
	position += velocity * delta
	position = Vector2(max(32, min(1200 - 32, position.x)), position.y)
	
func _process(delta):
	control(delta)
	

