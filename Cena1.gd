extends Node2D

const enemy_scene = preload("res://ENEMY1.tscn")

func _ready() -> void:
	spawn_enemy(200, -500)
	spawn_enemy(400, -500)
	spawn_enemy(600, -500)
	
	var player = get_node_or_null("Player") 
	if player:
		player.vida_mudou.connect(_atualizar_hud)
		_atualizar_hud(player.hp) 

func _atualizar_hud(nova_vida: int) -> void:
	var barra = get_node_or_null("HUD/BarraVida")
	var texto = get_node_or_null("HUD/TextoVida")

	if barra:
		barra.value = nova_vida
		barra.max_value = 100

	if texto:
		if nova_vida > 0:
			texto.text = "HP: " + str(nova_vida) + " / 100"
		else:
			texto.text = "GAME OVER"

func spawn_enemy(x: float, y: float):
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(x, y)
	add_child(enemy)
