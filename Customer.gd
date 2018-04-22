extends Area2D

export (PackedScene) var consuming
export (int) var speed = 5
export (String) var state = "COMING"
export (NodePath) var assigned_seat_position

func _ready():
	$AnimatedSprite.play()

func _process(delta):
	if consuming:
		$BeerThoughtBubble.visible = false
		if consuming.empty:
			state = "LEAVING"
			consuming = null
	elif state == "LEAVING":
		$BeerThoughtBubble.visible = false
	else:
		$BeerThoughtBubble.visible = true

	if state == "COMING":
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = false
		position.x += speed
		if (position.x >= get_node(assigned_seat_position).position.x):
			state = "SITTING"
	elif state == "LEAVING":
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = true
		position.x -= speed
	elif state == "SITTING":
		$AnimatedSprite.animation = "sit"


func _on_Beer_taken_by(taken, taker):
	if (taker == self) and not taken.empty:
		taken.position = position + $BeerPosition.position
		consuming = taken
