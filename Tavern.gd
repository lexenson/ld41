extends Node


func _on_Timer_timeout():
	$Timer.start()
	

func _on_Beer_taken_by(taken, taker):
	for customer in get_node("Customers").get_children():
		customer._on_Beer_taken_by(taken, taker)
