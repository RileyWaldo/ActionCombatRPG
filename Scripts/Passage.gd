extends StaticBody3D
class_name Passage

@export_file("*.tscn") var nextLevel

func Travel(player: Player) -> void:
	SceneTransition.ChangeScene(nextLevel, player)
