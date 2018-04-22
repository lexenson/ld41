extends Area2D

export (PackedScene) var consuming


func _ready():
	pass
	
func _process(delta):
	if consuming:
		$BeerThoughtBubble.visible = false
	else:
		$BeerThoughtBubble.visible = true


func _on_Beer_taken_by(taken, taker):
	if (taker.name == name) and not taken.empty:
		taken.position = position + $BeerPosition.position
		consuming = taken
	else:
		consuming = null