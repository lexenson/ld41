extends Area2D

export (bool) var flip = true

var empty = false
signal taken_by(taken, taker)
var can_be_taken = true


func _ready():
	$NoSwapTimer.connect("timeout", self, "set_can_be_taken")

func set_can_be_taken():
	can_be_taken = true	

func _on_Coin_area_entered(area):
	var parent = area.get_parent()
	if area.name == "Player" and can_be_taken and (not area.holding or area.holding.can_be_taken):
		if area.holding:
			area.holding.position = self.position
		can_be_taken = false
		$NoSwapTimer.start()
		emit_signal("taken_by", self, area)
	if area.name == "RegisterArea":
		print("Money brought to Register")
		emit_signal("taken_by", self,  area)
		queue_free()

