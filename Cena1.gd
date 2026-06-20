extends Node2D

const ENEMY_SCENE := preload("res://ENEMY1.tscn")

@onready var player: CharacterBody2D = get_node_or_null("Player")
@onready var vida_barra: ProgressBar = get_node_or_null("HUD/BarraVida")
@onready var vida_texto: Label = get_node_or_null("HUD/TextoVida")

func _ready() -> void:
spawn_enemy(200, -500)
spawn_enemy(400, -500)
spawn_enemy(600, -500)

if player:
player.vida_mudou.connect(_atualizar_hud)
_atualizar_hud(player.hp)

func _atualizar_hud(nova_vida: int) -> void:
if vida_barra:
vida_barra.value = nova_vida
vida_barra.max_value = 100

if vida_texto:
if nova_vida > 0:
vida_texto.text = "HP: %d / 100" % nova_vida
else:
vida_texto.text = "GAME OVER"

func spawn_enemy(x: float, y: float) -> void:
var enemy := ENEMY_SCENE.instantiate()
enemy.position = Vector2(x, y)
add_child(enemy)
