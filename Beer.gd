extends Area2D

export (bool) var flip = false
var empty = false
signal taken_by(taken, taker)

func _process(delta):
	$AnimatedSprite.flip_h = flip
	

func _on_Beer_area_entered(area):
	var parent = area.get_parent()
	if area.name == "Player":
		emit_signal("taken_by", self, area)
	if parent.name == "Customers" and not empty and area.get('state') == 'SITTING':
		emit_signal("taken_by", self, area)
	if area.name == "BarArea" and empty:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play('fill')
		emit_signal("taken_by", self, area)
		position.y =  area.global_position.y - 72

func start_drinking():
	$CollisionShape2D.disabled = true
	$AnimatedSprite.play('drink')

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = not empty
	$CollisionShape2D.disabled = false
	
