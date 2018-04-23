extends CanvasLayer

func _ready():
	get_parent().connect("coins_changed", self, "update_coins")
	get_parent().connect("shift_ended", self, "show_text")
	get_parent().connect("restart", self, "hide_text")
	$Label.visible = false

func update_coins(coins, total_coins):
	$Label.text = "The shift is over!\n\n\nCoins collected: %s\nTotal coins: %s" % [str(coins), str(total_coins)]
	
func show_text():
	$Label.visible = true
	
func hide_text():
	$Label.visible = false