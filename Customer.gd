extends Area2D

export (PackedScene) var consuming
export (int) var speed = 5
export (String) var state = "ARRIVING"
export (NodePath) var assigned_seat_position

var stop_position
const door_position_x = 0


signal paid(customer)
signal looking_for_seat(customer)

func _ready():
	position.x = -100
	position.y = 717
	$AnimatedSprite.play()
	stop_position = round(rand_range(-100, 200))

func _process(delta):
	if state == "ARRIVING":
		$ThoughtBubble.visible = false
		position.x += speed
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = false
		if position.x >= stop_position:
			state = "WAITING"
			$AnimatedSprite.animation = "idle"
	elif state == "WAITING":
		$ThoughtBubble.visible = false
		$AnimatedSprite.animation = "idle"
		show_table_bubble()		
	elif state == "COMING":
		$ThoughtBubble.visible = false		
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = false
		position.x += speed
		if (position.x >= get_node(assigned_seat_position).position.x):
			state = "SITTING"
		$CollisionShape2D.disabled = true
	elif state == "LEAVING":
		$ThoughtBubble.visible = false		
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = position.x > door_position_x
		if position.x >= door_position_x:
			position.x -= speed
			if position.y <= door_position_x:
				queue_free()
		elif  position.x <= door_position_x:
			position.x += speed
			if position.y >= door_position_x:
				queue_free()
		$CollisionShape2D.disabled = true		
	elif state == "SITTING":
		show_beer_bubble()
		$AnimatedSprite.animation = "sit"
		$CollisionShape2D.disabled = false
		if consuming:
			state = "DRINKING"
	elif state == "DRINKING":
		$ThoughtBubble.visible = false
		$AnimatedSprite.animation = "sit"
		$CollisionShape2D.disabled = true
		if consuming and consuming.empty:
			state = "PAYING"
			consuming = null
	elif state == "PAYING":
		$CollisionShape2D.disabled = false
		show_coin_bubble()
		$AnimatedSprite.animation = "sit"
		
func show_coin_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = true
	$ThoughtBubble/Beer.visible = false
	$ThoughtBubble/Table.visible = false
	
func show_beer_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = true
	$ThoughtBubble/Table.visible = false

func show_table_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = false
	$ThoughtBubble/Table.visible = true


func _on_Beer_taken_by(taken, taker):
	if taker == self:
		taken.start_drinking()
		taken.position = position + $BeerPosition.position
		consuming = taken

func _on_Customer_area_entered(area):
	if area.name == "Player":
		if state == "PAYING" and not area.holding:
			state = "LEAVING"
			emit_signal("paid", self)
		elif state == "WAITING":
			emit_signal("looking_for_seat", self)
