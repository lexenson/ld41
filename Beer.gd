extends Area2D

export (bool) var flip = false

func _ready():
	print("Beeeeer!")

func _process(delta):
	$Sprite.flip_h = flip
	


func _on_Beer_area_entered(area):
	if area.name == "Player":
		area.holding = self

