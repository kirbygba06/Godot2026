extends CharacterBody2D


signal vida_mudou(nova_vida: int)

const SPEED := 300.0
const JUMP_VELOCITY := -450.0
const BASE_GRAVITY := 1200.0
const FALL_GRAVITY_MULTIPLIER := 1.8
const COYOTE_TIME := 0.12
const JUMP_BUFFER_TIME := 0.15
const SHOOT_COOLDOWN := 0.2

var fall_gravity_multiplier: float = FALL_GRAVITY_MULTIPLIER
var coyote_time: float = COYOTE_TIME
var jump_buffer_time: float = JUMP_BUFFER_TIME
var facing_direction: float = 1.0
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var hp: int = 100
var shoot_cooldown_timer: float = 0.0

const BULLET_SCENE := preload("res://bullet.tscn")

@onready var muzzle: Marker2D = $Muzzle

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var current_gravity := BASE_GRAVITY
		if velocity.y > 0:
			current_gravity *= fall_gravity_multiplier
		velocity.y += current_gravity * delta
	else:
		coyote_timer = coyote_time
	
	if coyote_timer > 0:
		coyote_timer -= delta
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
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

func shoot() -> void:
	var bullet := BULLET_SCENE.instantiate()
	var muzzle_offset := muzzle.position
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
