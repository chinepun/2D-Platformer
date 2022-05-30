extends Camera2D

var target_position = Vector2.ZERO

export(Color, RGB) var backgroundColor
export(OpenSimplexNoise) var shakeNoise;

var xNoiseSampleVector = Vector2.RIGHT
var yNoiseSampleVector = Vector2.DOWN

var noiseSampleTravelRate = 500
var maxShakeOffset = 6
var currentShakePercentage = 0
var shakeDecay = 4
var xNoiseSamplePosition = Vector2.ZERO
var yNoiseSamplePosition = Vector2.ZERO

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
	apply_shake(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target_position()
	global_position = lerp(target_position, global_position, pow(2, -15 * delta))
	if (currentShakePercentage > 0):
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta;
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta;

		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y);
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y);
		
		var calculatedOffset = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		offset = calculatedOffset;
		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)

func apply_shake(percentage):
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)

func acquire_target_position():
	var acquired = get_target_position_from_node_group("player")
	if (!acquired):
		get_target_position_from_node_group("player_death")
	var players = get_tree().get_nodes_in_group("player")

	if (players.size() > 0):
		var player = players[0]
		target_position = player.global_position
	else:
		pass

func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		var node = nodes[0]
		target_position = node.global_position
		return true
	return false
