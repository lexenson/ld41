extends Area2D

export (PackedScene) var consuming
export (String) var initial_animation = 'sit'

var leaving = false

func _ready():
	$AnimatedSprite.animation = initial_animation
	$AnimatedSprite.play()

func _process(delta):
	$BeerThoughtBubble.visible = false
	if consuming and consuming.empty:
		leaving = true
		consuming = null
	elif leaving:
		$BeerThoughtBubble.visible = false
	else:
		$BeerThoughtBubble.visible = true

	if leaving:
		position.x -= 20


func _on_Beer_taken_by(taken, taker):
	if (taker == self) and not taken.empty:
		taken.position = position + $BeerPosition.position
		consuming = taken