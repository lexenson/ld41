extends Area2D

export (bool) var flip = false
var empty = false
signal beer_placed_on_bar

func _process(delta):
	$AnimatedSprite.flip_h = flip
	

func _on_Beer_area_entered(area):
	if area.name == "Player":
		area.holding = self
	if area.name == "Customer" and not empty:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play('drink')
	if area.name == "BarArea" and empty:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play('fill')
		emit_signal('beer_placed_on_bar')
		print(area.global_position)
		position.y =  area.global_position.y - 72



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = not empty
	$CollisionShape2D.disabled = false
	
