extends Node

export (int) var coins = 0

var seats

func _ready():
	for customer in $Customers.get_children():
		customer.connect("paid", self, "customer_paid")
		customer.connect("looking_for_seat", self, "assign_customer_seat")
	
	seats = $Seats.get_children()
	
func assign_customer_seat(customer):
	print("assign seat")
	if (len(seats) > 0):
		customer.assigned_seat_position = seats.pop_front().get_path()
		customer.state = "COMING" 
	
func customer_paid():
	coins += 1
	$CoinHUD.get_node("Label").text = String(coins)

func _on_Beer_taken_by(taken, taker):
	for customer in $Customers.get_children():
		customer._on_Beer_taken_by(taken, taker)
