# SCRIPT DA CENA PRINCIPAL - Gerencia spawn de inimigos e UI do jogo

extends Node2D

var enemy_scene = preload("res://ENEMY1.tscn")

func _ready() -> void:
	# Cria dois inimigos em posições diferentes
	spawn_enemy(200, -500)
	spawn_enemy(300, -500)

func _process(_delta: float) -> void:
	# Atualiza o HP na tela
	var player = get_node_or_null("Player")
	if player:
		$Label.text = "HP: " + str(player.hp)
	else:
		$Label.text = "Game Over!"

func spawn_enemy(x: float, y: float):
	# Cria um novo inimigo na posição indicada
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(x, y)
	add_child(enemy)
