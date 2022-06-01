extends CanvasLayer

signal back_pressed;

onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var windowedButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowedButton
onready var musicRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var SFXRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen = false;

func _ready():
	windowedButton.connect("pressed", self, "on_window_pressed")
	backButton.connect("pressed", self, "on_backButton_pressed")
	musicRangeControl.connect("precentage_changed", self, "on_music_volume_changed")
	SFXRangeControl.connect("precentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()

func get_bus_volume_percent(busName):
	var busIdx = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIdx))
	return volumePercent

func update_initial_volume_settings():
	var musicPercent = get_bus_volume_percent("Music")
	musicRangeControl.set_current_percentage(musicPercent)
	
	var sfxPercent = get_bus_volume_percent("SFX")
	SFXRangeControl.set_current_percentage(sfxPercent)

func update_bus_volume(bus_name, volumePercentage):
	var busIdx = AudioServer.get_bus_index(bus_name)
	var volumeDb = linear2db(volumePercentage)
	AudioServer.set_bus_volume_db(busIdx, volumeDb)

func on_music_volume_changed(percent):
	update_bus_volume("Music", percent)

func on_sfx_volume_changed(percent):
	update_bus_volume("SFX", percent)

func on_backButton_pressed():
	emit_signal("back_pressed")

func on_window_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()

func update_display():
	windowedButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"
