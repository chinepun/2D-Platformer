extends CanvasLayer

func _ready():
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevel.connect("pressed", self, "on_next_button_pressed")
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Restart.connect("pressed", self, "on_restart_pressed")

func on_restart_pressed():
	$"/root/LevelManager".restart_level()

func on_next_button_pressed():
	$"/root/LevelManager".increment_level()
