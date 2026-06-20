extends Area2D

const SPEED = 800.0
var direction = 1.0
var damage: int = 10
var ja_colidiu = false 

func _ready() -> void:
	add_to_group("bullet")
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if ja_colidiu:
		return
	if area.is_in_group("hitbox_inimigo"):
		ja_colidiu = true
		
		var inimigo = area.get_parent()
		if inimigo.has_method("take_damage"):
			inimigo.take_damage(damage, direction)
			
		queue_free()

func _on_screen_exited() -> void:
	queue_free()
