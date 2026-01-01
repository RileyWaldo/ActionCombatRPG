extends CanvasLayer

@onready var fader: ColorRect = $Fader

func _ready() -> void:
	FadeIn()

func FadeIn() -> void:
	var tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_property(fader, "color:a", 0.0, 1.0).from(1.0)

func ChangeScene(nextLevel: String, player: Player) -> void:
	var tween = create_tween()
	tween.tween_property(fader, "color:a", 1.0, 1.0).from(0.0)
	tween.tween_interval(0.1)
	tween.tween_callback(
		func():
			get_tree().change_scene_to_file(nextLevel)
	)
