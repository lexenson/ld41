extends Area2D

export (PackedScene) var consuming
export (int) var speed = 5
export (String) var state = "ARRIVING"
export (NodePath) var assigned_seat_position

var stop_position
const door_position_x = 0
var craving
var animated_sprite


signal paid(customer)
signal looking_for_seat(customer)

func _ready():
	if randi() % 2 == 1:
		craving = "Beer"
	else:
		craving = "Food"
	if randi() % 2 == 1:
		$AnimatedSprite.visible = true
		$AnimatedSprite2.visible = false
		animated_sprite = $AnimatedSprite
	else:
		$AnimatedSprite.visible = false
		$AnimatedSprite2.visible = true
		animated_sprite = $AnimatedSprite2
	position.x = -100
	position.y = 717
	animated_sprite.play()
	stop_position = round(rand_range(-100, 200))

func _process(delta):
	if state == "ARRIVING":
		$ThoughtBubble.visible = false
		position.x += speed
		animated_sprite.animation = "walk"
		animated_sprite.flip_h = false
		if position.x >= stop_position:
			state = "WAITING"
			animated_sprite.animation = "idle"
	elif state == "WAITING":
		$ThoughtBubble.visible = false
		animated_sprite.animation = "idle"
		show_table_bubble()		
	elif state == "COMING":
		$ThoughtBubble.visible = false		
		animated_sprite.animation = "walk"
		animated_sprite.flip_h = false
		var target_position = get_node(assigned_seat_position).position.x
		animated_sprite.flip_h = position.x > target_position
		if position.x >= target_position:
			position.x -= speed
			if position.x <= target_position:
				state = "SITTING"
		elif  position.x <= target_position:
			position.x += speed
			if position.x >= target_position:
				state = "SITTING"
		$CollisionShape2D.disabled = true
	elif state == "LEAVING":
		$ThoughtBubble.visible = false		
		animated_sprite.animation = "walk"
		animated_sprite.flip_h = position.x > door_position_x
		if position.x >= door_position_x:
			position.x -= speed
			if position.x <= door_position_x:
				queue_free()
		elif  position.x <= door_position_x:
			position.x += speed
			if position.x >= door_position_x:
				queue_free()
		$CollisionShape2D.disabled = true		
	elif state == "SITTING":
		if craving == "Beer":
			show_beer_bubble()
		elif craving == "Food":
			show_food_bubble()
		animated_sprite.animation = "sit"
		$CollisionShape2D.disabled = false
		if consuming:
			state = "CONSUMING"
	elif state == "CONSUMING":
		$ThoughtBubble.visible = false
		animated_sprite.animation = "sit"
		$CollisionShape2D.disabled = true
		if consuming and consuming.empty:
			state = "PAYING"
			consuming = null
	elif state == "PAYING":
		$CollisionShape2D.disabled = false
		show_coin_bubble()
		animated_sprite.animation = "sit"
		
func show_coin_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = true
	$ThoughtBubble/Beer.visible = false
	$ThoughtBubble/Table.visible = false
	$ThoughtBubble/Food.visible = false
	
func show_beer_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = true
	$ThoughtBubble/Table.visible = false
	$ThoughtBubble/Food.visible = false
	
func show_food_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = false
	$ThoughtBubble/Table.visible = false
	$ThoughtBubble/Food.visible = true

func show_table_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = false
	$ThoughtBubble/Table.visible = true
	$ThoughtBubble/Food.visible = false


func _on_Beer_taken_by(taken, taker):
	if taker == self:
		taken.start_drinking()
		taken.position = position + $BeerPosition.position
		consuming = taken
		
func _on_Food_taken_by(taken, taker):
	if taker == self:
		taken.start_eating()
		taken.position = position + $BeerPosition.position
		consuming = taken

func _on_Customer_area_entered(area):
	if area.name == "Player":
		if state == "PAYING" and not area.holding:
			state = "LEAVING"
			emit_signal("paid", self)
		elif state == "WAITING":
			emit_signal("looking_for_seat", self)
