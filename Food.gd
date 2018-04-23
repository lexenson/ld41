extends Area2D

export (bool) var flip = false
var empty = false
signal taken_by(taken, taker)
var can_be_taken = true


func _ready():
	$NoSwapTimer.connect("timeout", self, "set_can_be_taken")

func _process(delta):
	$AnimatedSprite.flip_h = flip
	
func set_can_be_taken():
	can_be_taken = true	

func _on_Food_area_entered(area):
	var parent = area.get_parent()
	if area.name == "Player" and can_be_taken and (not area.holding or area.holding.can_be_taken):
		if area.holding:
			area.holding.position = self.position
		can_be_taken = false
		$NoSwapTimer.start()
		emit_signal("taken_by", self, area)
	if parent.name == "Customers" and not empty and area.get('state') == 'SITTING' and area.craving == 'Food':
		emit_signal("taken_by", self, area)
	if area.name == "StoveArea" and (empty or can_be_taken):
		if empty:
			$CollisionShape2D.disabled = true
			$AnimatedSprite.play('cook')
		else:
			can_be_taken = false
			$NoSwapTimer.start()
		emit_signal("taken_by", self, area)
		position.y =  area.global_position.y - 12

func start_eating():
	$CollisionShape2D.disabled = true
	$AnimatedSprite.play('eat')

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = not empty
	$CollisionShape2D.disabled = false