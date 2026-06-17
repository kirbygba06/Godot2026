extends CharacterBody2D

# ===== SINAIS =====
# Sinal emitido quando a vida muda (para a HUD escutar)
signal vida_mudou(nova_vida: int)

# ===== VARIÁVEIS DE MOVIMENTO =====
const SPEED = 300.0
const JUMP_VELOCITY = -250.0
var facing_direction = 1.0

# ===== VARIÁVEIS DE VIDA =====
var hp = 3

# ===== VARIÁVEIS DE TIRO =====
const SHOOT_COOLDOWN = 0.2
var shoot_cooldown_timer = 0.0

# ===== CENAS =====
const bullet_scene = preload("res://bullet.tscn")

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	if direction != 0:
		facing_direction = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, 1500.0 * delta)
	
	# Sistema de tiro
	shoot_cooldown_timer -= delta
	if Input.is_action_pressed("ui_select") and shoot_cooldown_timer <= 0:
		shoot()
		shoot_cooldown_timer = SHOOT_COOLDOWN
	
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + Vector2(50 * facing_direction, -15)
	bullet.direction = facing_direction
	get_parent().add_child(bullet)

func take_damage(amount: int) -> void:
	hp -= amount
	vida_mudou.emit(hp)  # AVISA A HUD QUE A VIDA MUDOU!
	
	if hp <= 0:
		hp = 0
		queue_free()
