# =====================================================================
# SCRIPT DO PERSONAGEM PRINCIPAL (PLAYER)
# =====================================================================
# Este script controla o movimento, pulo, tiro e recebimento de dano
# do personagem jogável. É um CharacterBody2D que interage com a física.
# =====================================================================

extends CharacterBody2D

# ===== VARIÁVEIS DE MOVIMENTO =====
var SPEED = 300.0                  # Velocidade de movimento horizontal (pixels por segundo)
var JUMP_VELOCITY = -250.0         # Velocidade do pulo (negativa = para cima)
var facing_direction = 1.0         # Direção que o player está olhando (1 = direita, -1 = esquerda)

# ===== VARIÁVEIS DE VIDA =====
var hp = 3                         # Pontos de vida do player (começa com 3)

# ===== VARIÁVEIS DE TIRO =====
var SHOOT_COOLDOWN = 0.2           # Tempo em segundos entre cada tiro (0.2 = 200 milissegundos)
var shoot_cooldown_timer = 0.0     # Contador de tempo para o cooldown de tiro

# ===== CENAS PRECARREGADAS =====
# Importa a cena da bala para poder criar novas balas quando o player atira
const bullet_scene = preload("res://bullet.tscn")

# =====================================================================
# FUNÇÃO _ready() - Executada UMA VEZ quando o node entra na cena
# =====================================================================
func _ready() -> void:
	# Adiciona o player a um grupo chamado "player"
	# Isso permite que outros scripts (como os inimigos) identifiquem o player
	add_to_group("player")

# =====================================================================
# FUNÇÃO _physics_process() - Executada a cada frame para física
# =====================================================================
# delta = tempo decorrido desde o último frame (em segundos)
func _physics_process(delta: float) -> void:
	
	# ===== APLICAR GRAVIDADE =====
	# Se o player não está no chão, aplica a gravidade (faz cair)
	if not is_on_floor():
		# get_gravity() retorna a gravidade do projeto (padrão: 980)
		# Multiplicamos por delta para tornar o movimento independente da taxa de frames
		velocity += get_gravity() * delta
	
	# ===== PULO =====
	# "ui_accept" é Espaço | is_on_floor() verifica se está no chão
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# ===== MOVIMENTO HORIZONTAL =====
	# get_axis() retorna: -1 (esquerda), 0 (parado) ou 1 (direita)
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	# Se está se movendo, atualiza a direção que olha
	if direction != 0:
		facing_direction = sign(direction)  # 1 ou -1
	else:
		# Desacelera gradualmente quando para
		velocity.x = move_toward(velocity.x, 0, 1500.0 * delta)
	
	# ===== SISTEMA DE TIRO =====
	shoot_cooldown_timer -= delta
	
	if Input.is_action_pressed("ui_select") and shoot_cooldown_timer <= 0:
		shoot()
		shoot_cooldown_timer = SHOOT_COOLDOWN
	
	move_and_slide()  # Aplica movimento e detecta colisões

# =====================================================================
# FUNÇÃO shoot() - Cria uma bala e a coloca no mapa
# =====================================================================
func shoot():
	# Instantiate() cria uma cópia da cena bullet.tscn
	var bullet = bullet_scene.instantiate()
	
	# Define a posição da bala
	# global_position é a posição do player
	# Vector2(50 * facing_direction, -15) offseta a bala para cima e para o lado
	bullet.global_position = global_position + Vector2(50 * facing_direction, -15)
	
	# Passa a direção da bala (1 = direita, -1 = esquerda)
	bullet.direction = facing_direction
	
	# Adiciona a bala como filho do pai do player (a cena principal)
	# Isso faz a bala aparecer no mapa
	get_parent().add_child(bullet)

# =====================================================================
# FUNÇÃO take_damage() - O player recebe dano
# =====================================================================
# amount = quantidade de dano recebido
func take_damage(amount: int) -> void:
	# Diminui o HP
	hp -= amount
	
	# Se a vida chegou a zero ou menos, o player morre
	if hp <= 0:
		hp = 0
		# queue_free() marca o player para ser deletado no final do frame
		queue_free()  # Player morre
