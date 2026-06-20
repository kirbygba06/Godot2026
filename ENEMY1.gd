extends CharacterBody2D

const PATROL_SPEED = 100.0
const CHASE_SPEED = 150.0
const VISION_RANGE = 250.0
const DAMAGE_RANGE = 50.0
const DAMAGE_INTERVAL = 0.8
const GRAVITY = 400.0

var direction = -1.0
var player_ref: Node = null
var damage_timer = DAMAGE_INTERVAL
var hp: int = 30 
var original_modulate: Color 

func _ready() -> void:
	if has_node("Hitbox"):
		$Hitbox.add_to_group("hitbox_inimigo")
	if has_node("ColorRect"):
		original_modulate = $ColorRect.modulate
	elif has_node("Sprite2D"):
		original_modulate = $Sprite2D.modulate
		
	$Vision.body_entered.connect(_on_body_entered)
	$Vision.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	var speed = PATROL_SPEED
	if player_ref and is_instance_valid(player_ref):
		var distance = global_position.distance_to(player_ref.global_position)
		
		if distance < VISION_RANGE:
			speed = CHASE_SPEED
			direction = sign(player_ref.global_position.x - global_position.x)
			
			
			if distance < DAMAGE_RANGE:
				damage_timer -= delta
				if damage_timer <= 0:
					if player_ref.has_method("take_damage"):
						player_ref.take_damage(1)
					damage_timer = DAMAGE_INTERVAL
	velocity.x = direction * speed
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_ref = body

func _on_body_exited(body: Node) -> void:
	if body == player_ref:
		player_ref = null

func take_damage(amount: int, bullet_direction: float) -> void:
	hp -= amount
	if has_node("ColorRect"):
		$ColorRect.modulate = Color.RED
	elif has_node("Sprite2D"):
		$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if has_node("ColorRect"):
		$ColorRect.modulate = original_modulate
	elif has_node("Sprite2D"):
		$Sprite2D.modulate = original_modulate
	position.x += bullet_direction * 30.0 
	if hp <= 0:
		queue_free()
