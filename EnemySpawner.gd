extends Position2D
enum Direction { RIGHT, LEFT }

export(PackedScene) var enemy_scene;
export(Direction) var startDirection

var currentEnemyNode = null;
var spawnOnNextTick = false

func _ready():
	$SpawnTimer.connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy")

func spawn_enemy():
	currentEnemyNode = enemy_scene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

func checkEnemySpawn():
	if (!is_instance_valid(currentEnemyNode)):
		if (!spawnOnNextTick):
			spawn_enemy()
			spawnOnNextTick = false
		else:
			spawnOnNextTick = true

func on_spawn_timer_timeout():
	checkEnemySpawn();
