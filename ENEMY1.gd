# =====================================================================
# SCRIPT DO INIMIGO
# =====================================================================
# Este script controla o comportamento do inimigo: movimento horizontal,
# detecção de colisão com o player e aplicação de dano periódico.
# =====================================================================

extends CharacterBody2D

# ===== VARIÁVEIS DE MOVIMENTO =====
var speed := 100.0                 # Velocidade atual (muda entre patrulha e perseguição)
var direction := -1.0              # Direção (-1 = esquerda, 1 = direita)
var gravity := 400.0

# ===== VARIÁVEIS DE VIDA =====
var hp := 1

# ===== VARIÁVEIS DE VISÃO E PERSEGUIÇÃO =====
var patrol_speed := 100.0          # Velocidade ao patrulhar
var chase_speed := 150.0           # Velocidade ao perseguir
var vision_range := 250.0          # Raio de detecção do player (ajustado para caber na Area2D)

# ===== VARIÁVEIS DE DANO =====
var damage_interval := 0.8
var damage_timer := 0.0
var player_body: Node = null       # null = não vê o player

# =====================================================================
# FUNÇÃO _ready() - Executada UMA VEZ quando o inimigo entra na cena
# =====================================================================
func _ready() -> void:
	# Ativa detecção de colisão da Area2D
	$Area2D.monitoring = true
	$Area2D.monitorable = true
	
	# Conecta sinais (eventos) da Area2D a funções deste script
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Area2D.area_entered.connect(_on_area_entered)
	
	damage_timer = damage_interval

# =====================================================================
# FUNÇÃO _process() - Executada a cada frame
# =====================================================================
# delta = tempo decorrido desde o último frame (em segundos)
func _process(delta: float) -> void:
	
	# Aplicar gravidade se não está no chão
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# ===== SISTEMA DE VISÃO =====
	# Verifica se há player dentro do raio de visão
	if player_body and is_instance_valid(player_body):
		# Calcula a distância até o player
		var distance_to_player = global_position.distance_to(player_body.global_position)
		
		# Se player está dentro do raio de visão
		if distance_to_player < vision_range:
			# PERSEGUIR: Calcula a direção para o player
			if player_body.global_position.x > global_position.x:
				direction = 1.0
			else:
				direction = -1.0
			speed = chase_speed  # Aumenta velocidade na perseguição
		else:
			# PATRULHAR: Player detectado mas fora do raio, continua patrulhando
			speed = patrol_speed  # Volta à velocidade normal
	else:
		# Sem player detectado, patrulha normalmente
		speed = patrol_speed
	
	# Movimento contínuo na direção atual
	velocity.x = direction * speed
	move_and_slide()

	# Aplicar dano se há player na área de contato (APENAS com Area2D pequena)
	if player_body and is_instance_valid(player_body):
		var dist_for_damage = global_position.distance_to(player_body.global_position)
		# Só aplica dano se está REALMENTE perto (dentro de 50 pixels)
		if dist_for_damage < 50.0:
			damage_timer -= delta
			if damage_timer <= 0.0:
				_damage_player()
				damage_timer = damage_interval

# =====================================================================
# FUNÇÃO _on_body_entered() - Chamada quando um corpo entra na Area2D
# =====================================================================
func _on_body_entered(body: Node) -> void:
	if _is_player(body):
		player_body = body

# =====================================================================
# FUNÇÃO _on_body_exited() - Chamada quando um corpo sai da Area2D
# =====================================================================
func _on_body_exited(body: Node) -> void:
	if _is_player(body) and body == player_body:
		player_body = null

# =====================================================================
# FUNÇÃO _damage_player() - Causa dano ao player
# =====================================================================
func _damage_player() -> void:
	if player_body and player_body.has_method("take_damage"):
		player_body.take_damage(1)

# =====================================================================
# FUNÇÃO _is_player() - Verifica se um node é o player
# =====================================================================
func _is_player(body: Node) -> bool:
	return body.name == "Player" or body.is_in_group("player")

# =====================================================================
# FUNÇÃO _on_area_entered() - Chamada quando uma bala atinge o inimigo
# =====================================================================
func _on_area_entered(area: Area2D) -> void:
	if area.name == "Bullet":
		hp -= 1
		area.queue_free()
		if hp <= 0:
			queue_free()
