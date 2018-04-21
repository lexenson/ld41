extends Area2D

export (bool) var flip = false
var empty = false

func _process(delta):
	$AnimatedSprite.flip_h = flip
	

func _on_Beer_area_entered(area):
	if area.name == "Player":
		area.holding = self
	if area.name == "Customer" and not empty:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play('drink')



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = true
	$CollisionShape2D.disabled = false
	
