extends Button

export(bool) var disableHoverAnim;

func _ready():
	connect("mouse_entered", self, "on_mouse_entered");
	connect("mouse_exited", self, "on_mouse_exited");
	connect("pressed", self, "on_pressed")

func on_mouse_entered():
	if (!disableHoverAnim):
		$HoverAnimationPlayer.play("hover")

func on_pressed():
	$AudioStreamPlayer.play()
	$ClickAnimationPlayer.play("click")

func _process(delta):
	rect_pivot_offset = rect_min_size / 2

func on_mouse_exited():
	reset_button_state()

func reset_button_state():
	if (!disableHoverAnim):
		$HoverAnimationPlayer.play_backwards("hover")

func _on_AnimationButton_focus_exited():
	reset_button_state()
