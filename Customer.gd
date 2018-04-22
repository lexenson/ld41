extends Area2D

export (PackedScene) var consuming
export (int) var speed = 20

var leaving = false

func _process(delta):
	if consuming:
		$BeerThoughtBubble.visible = false
		if consuming.empty:
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