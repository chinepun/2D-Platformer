extends HBoxContainer

var currentPercentage = 1.0
signal precentage_changed;

func set_current_percentage(percent):
	currentPercentage = clamp(percent, 0, 1)
	
	var labelNumber = currentPercentage * 10
	labelNumber = round(labelNumber)
	
	$Label.text = str(labelNumber)
	emit_signal("precentage_changed", currentPercentage)

func _ready():
	$SubtractButton.connect("pressed", self, "on_button_pressed", [-.1])
	$AddButton.connect("pressed", self, "on_button_pressed", [.1])

func on_button_pressed(change):
	set_current_percentage(currentPercentage + change)
