extends Area2D

signal taking_beer

export (PackedScene) var consuming


func _ready():
	pass

func _on_Customer_area_entered(area):
	if (area.name == "Beer"):
		consuming = area
		area.position = self.position + $BeerPosition.position
		emit_signal("taking_beer")
