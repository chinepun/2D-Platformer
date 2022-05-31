extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Play;
onready var optionsButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Options;
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Quit;

func _ready():
	playButton.connect("pressed", self, "on_play_pressed");
	quitButton.connect("pressed", self, "on_quit_pressed");

func on_play_pressed():
	$"/root/LevelManager".change_level(0)


func on_quit_pressed():
	get_tree().quit();
