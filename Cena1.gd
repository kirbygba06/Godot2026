extends Node2D

const enemy_scene = preload("res://ENEMY1.tscn")

func _ready() -> void:
	spawn_enemy(200, -500)
	spawn_enemy(300, -500)
	
	# Conecta o sinal do player à HUD
	var player = get_node_or_null("Player")
	if player:
		player.vida_mudou.connect(_atualizar_hud)
		_atualizar_hud(player.hp)  # Atualiza no início

func spawn_enemy(x: float, y: float):
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(x, y)
	add_child(enemy)

func _atualizar_hud(nova_vida: int) -> void:
	# 🔥 Esta função será chamada SEMPRE que a vida mudar
	if nova_vida > 0:
		$Label.text = "HP: " + str(nova_vida)
	else:
		$Label.text = "Game Over!"
