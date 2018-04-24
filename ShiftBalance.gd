extends CanvasLayer

func _ready():
	get_parent().connect("coins_changed", self, "update_coins")
	get_parent().connect("shift_ended", self, "show")
	get_parent().connect("restart", self, "hide")
	$Label.visible = false
	$ColorRect.visible = false

func update_coins(coins, total_coins):
	$Label.text = "The shift is over\n\n\nShift: %sg\n\nTotal: %sg" % [str(coins), str(total_coins)]
	
func show():
	$Label.visible = true
	$ColorRect.visible = true
	
func hide():
	$Label.visible = false
	$ColorRect.visible = false