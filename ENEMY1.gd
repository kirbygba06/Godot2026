extends CharacterBody2D

# ===== VARIÁVEIS =====
const PATROL_SPEED = 100.0
const CHASE_SPEED = 150.0
const VISION_RANGE = 250.0
const DAMAGE_RANGE = 50.0
const DAMAGE_INTERVAL = 0.8
const GRAVITY = 400.0

var direction = -1.0
var hp = 1
var player_ref: Node = null
var damage_timer = DAMAGE_INTERVAL

func _ready() -> void:
	# 🔥 Usa a $Vision (grande) para detectar o player
	$Vision.body_entered.connect(_on_body_entered)
	$Vision.body_exited.connect(_on_body_exited)
	
	# 🔥 Usa a $Hitbox (pequena) para receber dano de balas
	$Hitbox.area_entered.connect(_on_hitbox_entered)

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Movimento
	var speed = PATROL_SPEED
	
	if player_ref and is_instance_valid(player_ref):
		var distance = global_position.distance_to(player_ref.global_position)
		
		if distance < VISION_RANGE:
			speed = CHASE_SPEED
			direction = sign(player_ref.global_position.x - global_position.x)
			
			# Dano por contato (usa a distância real, não a Area2D)
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

# 🔥 NOVA FUNÇÃO: Só é chamada quando a bala toca na Hitbox (corpo)
func _on_hitbox_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		hp -= 1
		area.queue_free() # Apaga a bala
		if hp <= 0:
			queue_free() # Apaga o inimigo
