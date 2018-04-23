extends Area2D

export (bool) var flip = false
var empty = false
signal taken_by(taken, taker)

func _process(delta):
	$AnimatedSprite.flip_h = flip
	

func _on_Food_area_entered(area):
	var parent = area.get_parent()
	if area.name == "Player" and not area.holding:
		emit_signal("taken_by", self, area)
	if parent.name == "Customers" and not empty and area.get('state') == 'SITTING':
		emit_signal("taken_by", self, area)
	if area.name == "StoveArea" and empty:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play('cook')
		emit_signal("taken_by", self, area)
		position.y =  area.global_position.y - 12

func start_eating():
	$CollisionShape2D.disabled = true
	$AnimatedSprite.play('eat')

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	empty = not empty
	$CollisionShape2D.disabled = false