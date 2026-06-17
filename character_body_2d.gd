# =====================================================================
# SCRIPT DE TEMPLATE (NÃO USADO NO JOGO)
# =====================================================================
# Este é um script padrão do Godot criado como template.
# O jogo usa mainchar.gd ao invés deste script.
# Mantido aqui como referência.
# =====================================================================

extends CharacterBody2D

# ===== CONSTANTES =====
# CONSTANTES são valores que NUNCA mudam durante o jogo
const SPEED = 300.0                # Velocidade de movimento (pixels por segundo)
const JUMP_VELOCITY = -400.0       # Velocidade do pulo (negativa = para cima)

# =====================================================================
# FUNÇÃO _physics_process() - Executada a cada frame para física
# =====================================================================
# delta = tempo decorrido desde o último frame (em segundos)
func _physics_process(delta: float) -> void:
	
	# ===== APLICAR GRAVIDADE =====
	# Se não está no chão, aplica a gravidade (faz cair)
	if not is_on_floor():
		# get_gravity() retorna a gravidade do projeto
		velocity += get_gravity() * delta

	# ===== PULO =====
	# Verifica se a ação "ui_accept" foi pressionada (espaço) e está no chão
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Define a velocidade Y para fazer o pulo
		velocity.y = JUMP_VELOCITY

	# ===== MOVIMENTO HORIZONTAL =====
	# get_axis("ui_left", "ui_right") retorna: -1 (esquerda), 0 (parado), 1 (direita)
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Se está se movendo (direction != 0)
	if direction:
		# Define a velocidade horizontal
		velocity.x = direction * SPEED
	else:
		# Se não está se movendo, desacelera gradualmente
		# move_toward(valor_atual, valor_alvo, quantidade) move suavemente
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# ===== APLICAR MOVIMENTO =====
	# Aplica a velocidade calculada e detecta colisões
	move_and_slide()
