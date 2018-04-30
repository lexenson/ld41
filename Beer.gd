extends Area2D

export (bool) var flip = false
var empty = false
signal taken_by(taken, taker)
var can_be_taken = true

func restart():
	position.x = 1023.330017
	position.y = 666.00
	$AnimatedSprite.animation = 'full'
	$AnimatedSprite.frame = 0
	empty = false
	$CollisionShape2D.disabled = false

func _ready():
	$NoSwapTimer.connect("timeout", self, "set_can_be_taken")

func _process(delta):
	$AnimatedSprite.flip_h = flip
	
func set_can_be_taken():
	can_be_taken = true
	

func _on_Beer_area_entered(area):
	var parent = area.get_parent()
	if area.name == "Player" and can_be_taken and (not area.holding or area.holding.can_be_taken):
		if area.holding:
			area.holding.position = self.position
		can_be_taken = false
		$NoSwapTimer.start()
		emit_signal("taken_by", self, area)
	if parent.name == "Customers" and not empty and area.get('state') == 'SITTING' and area.craving == "Beer":
		emit_signal("taken_by", self, area)
	if area.name == "BarArea" and (can_be_taken or empty):
		if empty:
			$CollisionShape2D.disabled = true
			$AnimatedSprite.play('fill')
		else:
			can_be_taken = false
			$NoSwapTimer.start()
		emit_signal("taken_by", self, area)
		position.y =  area.global_position.y - 72

func start_drinking():
	$CollisionShape2D.disabled = true
	$AnimatedSprite.play('drink')

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = not empty
	$CollisionShape2D.disabled = false
	
