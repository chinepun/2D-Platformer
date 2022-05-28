extends Camera2D

var target_position = Vector2.ZERO

export(Color, RGB) var backgroundColor

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
	print("hahaha")
	print(backgroundColor)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target_position()
	
	global_position = lerp(target_position, global_position, pow(2, -15 * delta))

func acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")

	if (players.size() > 0):
		var player = players[0]
		target_position = player.global_position
