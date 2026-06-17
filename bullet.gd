extends Area2D

const SPEED = 1500.0
var direction = 1.0

func _ready() -> void:
	add_to_group("bullet")  # Adiciona ao grupo "bullet"
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	# Se colidiu com algo que não é outra bala
	if not area.is_in_group("bullet"):
		queue_free()

func _on_screen_exited() -> void:
	queue_free()
