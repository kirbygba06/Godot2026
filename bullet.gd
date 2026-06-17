# =====================================================================
# SCRIPT DA BALA
# =====================================================================
# Este script controla o comportamento da bala: movimento contínuo,
# detecção de colisão e remoção quando sai da tela.
# =====================================================================

extends Area2D

# ===== VARIÁVEIS DE MOVIMENTO =====
var speed := 1500.0                # Velocidade da bala (pixels por segundo)
var direction := 1.0               # Direção da bala (1 = direita, -1 = esquerda)

# =====================================================================
# FUNÇÃO _ready() - Executada UMA VEZ quando a bala é criada
# =====================================================================
func _ready() -> void:
	name = "Bullet"
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	# Move a bala continuamente na direção indicada
	position.x += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	# Se bala colidiu com algo (não outra bala)
	if area.name != "Bullet":
		visible = false
		queue_free()

func _on_screen_exited() -> void:
	# Remove bala que saiu da tela (economiza memória)
	queue_free()
