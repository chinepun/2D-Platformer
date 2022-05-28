extends Node

signal coin_total_changed

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var total_coins = 0;
var collected_coins = 0

func _ready():
	spawnPosition = $Player.global_position
	register_player($Player)
	
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())

func coin_total_changed(new_total):
	total_coins = new_total
	emit_signal("coin_total_changed", total_coins, collected_coins)

func coin_collected():
	collected_coins += 1
	emit_signal("coin_total_changed", total_coins, collected_coins)

func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_dead", [], CONNECT_DEFERRED)

func on_player_dead():
	currentPlayerNode.queue_free()
	create_player()

func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
