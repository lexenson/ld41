extends Area2D

export (int) var speed = 300
export (int) var jump_speed = 1000

var velocity = Vector2()

func control(delta):
	velocity.x = 0
	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite.animation = 'walk'
		velocity.x = -1 * speed
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite.animation = 'walk'
		velocity.x = 1 * speed
		$AnimatedSprite.flip_h = false
		
	if Input.is_action_pressed('ui_up') and position.y == 800 - 64:
		velocity.y = -1 * jump_speed
		
	position += velocity * delta
	velocity.y += gravity
	
	if (velocity.x == 0 and velocity.y == 0):
		$AnimatedSprite.animation = 'idle'
		
	position = Vector2(max(32, min(1200 - 32, position.x)), min(800 - 64, position.y))
	
func _process(delta):
	control(delta)
	

