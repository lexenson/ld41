extends Area2D

export (PackedScene) var consuming
export (int) var speed = 5
export (String) var state = "COMING"
export (NodePath) var assigned_seat_position

signal paid

func _ready():
	$AnimatedSprite.play()

func _process(delta):
	if state == "COMING":
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
		$AnimatedSprite.flip_h = true
		position.x -= speed
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
	
func show_beer_bubble():
	$ThoughtBubble.visible = true
	$ThoughtBubble/Coin.visible = false
	$ThoughtBubble/Beer.visible = true


func _on_Beer_taken_by(taken, taker):
	if (taker == self) and not taken.empty and state != "PAYING":
		taken.position = position + $BeerPosition.position
		consuming = taken


func _on_Customer_area_entered(area):
	if area.name == "Player" and state == "PAYING" and not area.holding:
		state = "LEAVING"
		emit_signal("paid")
