extends Node

export (int) var coins = 0

func _ready():
	for customer in $Customers.get_children():
		customer.connect("paid", self, "customer_paid")
	
func customer_paid():
	coins += 1
	$CoinHUD.get_node("Label").text = String(coins)
	print(coins)

func _on_Beer_taken_by(taken, taker):
	for customer in get_node("Customers").get_children():
		customer._on_Beer_taken_by(taken, taker)
