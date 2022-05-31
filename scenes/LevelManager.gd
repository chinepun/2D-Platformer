extends Node

export(Array, PackedScene) var levelScenes;

var currentLevelIndex = 0


func increment_level():
	change_level(currentLevelIndex + 1)

func change_level(LevelIndex):
	currentLevelIndex = LevelIndex
	if (LevelIndex >= levelScenes.size()):
		currentLevelIndex = 0
	$"/root/ScreenTransitionManager".transition_to_scene(levelScenes[currentLevelIndex].resource_path)
