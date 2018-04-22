extends Node

export (int) var coins = 0
export (PackedScene) var customer_scene
export (int) var max_customers_in_queue

var seats

func _ready():
	$NewCustomerTimer.connect("timeout", self, "spawn_new_customer")
	
	for customer in $Customers.get_children():
		connect_customer(customer)
	
	seats = $Seats.get_children()
	
func assign_customer_seat(customer):
	if (len(seats) > 0):
		customer.assigned_seat_position = seats.pop_front().get_path()
		customer.state = "COMING" 
	
func customer_paid(customer):
	seats.append(get_node(customer.assigned_seat_position))
	customer.assigned_seat_position = null
	coins += 1
	$CoinHUD.get_node("Label").text = String(coins)
	
func connect_customer(customer):
	customer.connect("paid", self, "customer_paid")
	customer.connect("looking_for_seat", self, "assign_customer_seat")

func spawn_new_customer():
	if $Customers.get_children().size() < max_customers_in_queue:
		var customer = customer_scene.instance()
		$Customers.add_child(customer)
		connect_customer(customer)

func _on_Beer_taken_by(taken, taker):
	for customer in $Customers.get_children():
		customer._on_Beer_taken_by(taken, taker)
