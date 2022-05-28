extends Node2D

func _ready():
	$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")


func _on_Area2D_area_entered(_area):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
	var base_level = get_tree().get_nodes_in_group("base_level")[0]
	base_level.coin_collected()

func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
