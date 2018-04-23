extends Area2D

export (int) var speed = 300
export (int) var jump_speed = 1000
export (PackedScene) var holding

var velocity = Vector2()

func control(delta):
	velocity.x = 0
	var ground_touched = position.y == 800 - 64

	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite.animation = 'walk'
		velocity.x = -1 * speed
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite.animation = 'walk'
		velocity.x = 1 * speed
		$AnimatedSprite.flip_h = false
		
	if Input.is_action_pressed('ui_up') and ground_touched:
		velocity.y = -1 * jump_speed
		
	position += velocity * delta
	velocity.y += gravity
	
	if (velocity.x == 0 and ground_touched):
		$AnimatedSprite.animation = 'idle'
	
	if not ground_touched:
		$AnimatedSprite.animation = 'jump'
		
	position = Vector2(max(-1157, min(1200 - 32, position.x)), min(800 - 64, position.y))
	
func _process(delta):
	control(delta)
	if (holding):
		if $AnimatedSprite.flip_h:
			holding.flip = false
			holding.position = position + Vector2(-59, 15)
		else:
			holding.flip = true
			holding.position = position + Vector2(59, 15)

func _on_Beer_taken_by(taken, taker):
	if taker == self:
		holding = taken
	else:
		holding = null


func _on_Food_taken_by(taken, taker):
	if taker == self:
		holding = taken
	else:
		holding = null
