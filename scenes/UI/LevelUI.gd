extends CanvasLayer

func _ready():
	var base_levels = get_tree().get_nodes_in_group("base_level")
	
	if (base_levels.size() > 0):
		base_levels[0].connect("coin_total_changed", self, "on_coin_total_changed")

func on_coin_total_changed(total_coins, collected_coins):
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collected_coins, "/", total_coins)
