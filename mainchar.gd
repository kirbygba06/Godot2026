extends CharacterBody2D


signal vida_mudou(nova_vida: int)
var SPEED: float = 300.0
var JUMP_VELOCITY: float = -450.0 
var base_gravity: float = 1200.0
var fall_gravity_multiplier: float = 1.8 
var coyote_time: float = 0.12
var jump_buffer_time: float = 0.15
var facing_direction: float = 1.0
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var hp: int = 100 # Mudei para 100 para bater com a sua HUD da Cena1
var SHOOT_COOLDOWN: float = 0.2
var shoot_cooldown_timer: float = 0.0
const bullet_scene = preload("res://bullet.tscn")

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var current_gravity = base_gravity
		if velocity.y > 0: 
			current_gravity *= fall_gravity_multiplier
		velocity.y += current_gravity * delta
	else:
		coyote_timer = coyote_time 
	if coyote_timer > 0: coyote_timer -= delta
	if jump_buffer_timer > 0: jump_buffer_timer -= delta
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		facing_direction = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, 1500.0 * delta)
	shoot_cooldown_timer -= delta
	if Input.is_action_pressed("shoot") and shoot_cooldown_timer <= 0:
		shoot()
		shoot_cooldown_timer = SHOOT_COOLDOWN
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	var muzzle_offset = $Muzzle.position
	bullet.global_position = global_position + Vector2(muzzle_offset.x * facing_direction, muzzle_offset.y)
	bullet.direction = facing_direction
	get_parent().add_child(bullet)

func take_damage(amount: int) -> void:
	hp -= amount
	vida_mudou.emit(hp) 
	if hp <= 0:
		hp = 0
		get_tree().reload_current_scene() 
		queue_free()
