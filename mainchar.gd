extends CharacterBody2D

# ===== SINAIS (Mantido igual para não quebrar o Cena1.gd) =====
signal vida_mudou(nova_vida: int)

# ===== VARIÁVEIS DE MOVIMENTO (Ajustadas para um pulo melhor) =====
@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -450.0 # Aumentei o pulo
@export var base_gravity: float = 1200.0
@export var fall_gravity_multiplier: float = 1.8 # Cai mais rápido

# ===== GAME FEEL (A mágica) =====
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.15

var facing_direction: float = 1.0
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# ===== VARIÁVEIS DE VIDA (Mantido igual) =====
var hp: int = 3

# ===== VARIÁVEIS DE TIRO =====
@export var SHOOT_COOLDOWN: float = 0.2
var shoot_cooldown_timer: float = 0.0

# ===== CENAS =====
const bullet_scene = preload("res://bullet.tscn")

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# 1. GRAVIDADE CUSTOMIZADA
	if not is_on_floor():
		var current_gravity = base_gravity
		if velocity.y > 0: # Se estiver caindo, multiplica a gravidade
			current_gravity *= fall_gravity_multiplier
		velocity.y += current_gravity * delta
	else:
		coyote_timer = coyote_time # Enche o tanque do coyote no chão

	# 2. TIMERS
	if coyote_timer > 0: coyote_timer -= delta
	if jump_buffer_timer > 0: jump_buffer_timer -= delta

	# 3. BUFFER DE PULO
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time

	# 4. PULO (Só pula se tiver buffer e coyote)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	# 5. MOVIMENTO
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		facing_direction = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, 1500.0 * delta)

	# 6. TIRO (Mantido igual ao seu original)
	shoot_cooldown_timer -= delta
	# Agora usamos a ação "shoot" que criamos no Input Map
	if Input.is_action_pressed("shoot") and shoot_cooldown_timer <= 0:
		shoot()
		shoot_cooldown_timer = SHOOT_COOLDOWN

	move_and_slide()

# ===== TIRO (Vamos melhorar isso no PASSO 2) =====
func shoot():
	var bullet = bullet_scene.instantiate()
	
	# A MÁGICA DO MARKER2D:
	# Pegamos a posição X e Y do Marker2D que você arrastou na tela.
	# Multiplicamos o X pelo facing_direction (1 ou -1) para o tiro sair do lado certo!
	var muzzle_offset = $Muzzle.position
	bullet.global_position = global_position + Vector2(muzzle_offset.x * facing_direction, muzzle_offset.y)
	
	bullet.direction = facing_direction
	get_parent().add_child(bullet)

# ===== VIDA (Mantido EXATAMENTE como o Cena1.gd espera) =====
func take_damage(amount: int) -> void:
	hp -= amount
	vida_mudou.emit(hp) # Continua passando só 1 número!
	if hp <= 0:
		hp = 0
		queue_free()
