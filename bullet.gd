extends Area2D

const SPEED = 800.0
var direction = 1.0
var ja_colidiu = false  #  TRAVA ANTI-DANO DUPLO

func _ready() -> void:
	add_to_group("bullet")
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	# 🔥 Se já colidiu com algo, ignora qualquer outra coisa
	if ja_colidiu:
		return
	
	# 🔥 Só causa dano se tocar na Hitbox do inimigo (ignora a Vision)
	if area.is_in_group("hitbox_inimigo"):
		ja_colidiu = true  # Ativa a trava
		queue_free()       # Bala é destruída instantaneamente

func _on_screen_exited() -> void:
	queue_free()
