extends Node2D

signal player_won;

func _on_Area2D_area_entered(area):
	emit_signal("player_won")
	$Particles2D.emitting = true
	$AudioStreamPlayer.play()
