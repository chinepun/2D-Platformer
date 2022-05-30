extends Node

signal coin_total_changed

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var total_coins = 0;
var collected_coins = 0

func _ready():
	spawnPosition = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	$Flag.connect("player_won", self, "on_player_won");

func on_player_won():
	currentPlayerNode.queue_free()
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)

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
	print("timer don end")
	var timer = get_tree().create_timer(1)
	print("waiting")
	yield(timer, "timeout")
	print("new timer")
	create_player()

func create_player():
	var playerInstance = playerScene.instance()
	$PlayerRoot.add_child(playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
