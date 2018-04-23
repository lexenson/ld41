extends Node

export (int) var coins = 0
var total_coins = 0
export (PackedScene) var customer_scene
export (int) var max_customers_in_queue

signal coins_changed(coins, total_coins)
signal shift_ended()
signal restart()

var seats
var shift_ended = false
var state = "PLAYING"

func _ready():
	$NewCustomerTimer.connect("timeout", self, "spawn_new_customer")
	$Background/Clock.connect("animation_finished", self, "set_shift_ended")
	$ShiftBalanceTimer.connect("timeout", self, "restart")
	
	$Background/Clock.play()
	
	for customer in $Customers.get_children():
		connect_customer(customer)
	
	seats = $Seats.get_children()
	
func set_shift_ended():
	shift_ended = true
	
func restart():
	emit_signal("restart")
	coins = 0
	$"cash-register/CoinHUD/Label".text = String(coins)
	shift_ended = false
	state = "PLAYING"
	$Background/Clock.frame = 0
	$Background/Clock.play()
	$ShiftBalanceTimer.stop()
	
func _process(delta):
	if state == "PLAYING" and shift_ended and $Customers.get_children().size() == 0:
		emit_signal("shift_ended")
		$ShiftBalanceTimer.start()
		state = "BALANCE"
	
func assign_customer_seat(customer):
	if (len(seats) > 0):
		customer.assigned_seat_position = seats.pop_front().get_path()
		customer.state = "COMING" 
	
func customer_paid(customer):
	seats.append(get_node(customer.assigned_seat_position))
	customer.assigned_seat_position = null
	increment_coins()
	$"cash-register/CoinHUD/Label".text = String(coins)
	
func increment_coins():
	coins += 1
	total_coins += 1
	emit_signal("coins_changed", coins, total_coins)
	
func connect_customer(customer):
	customer.connect("paid", self, "customer_paid")
	customer.connect("looking_for_seat", self, "assign_customer_seat")

func spawn_new_customer():
	$NewCustomerTimer.wait_time = 5 + randi() % 5
	if $Customers.get_children().size() < max_customers_in_queue and not shift_ended:
		var customer = customer_scene.instance()
		$Customers.add_child(customer)
		connect_customer(customer)

func _on_Beer_taken_by(taken, taker):
	for customer in $Customers.get_children():
		customer._on_Beer_taken_by(taken, taker)
		
func _on_Food_taken_by(taken, taker):
	for customer in $Customers.get_children():
		customer._on_Food_taken_by(taken, taker)
