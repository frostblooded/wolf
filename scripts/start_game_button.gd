extends Button

var game_scene: PackedScene = load("res://scenes/Main.tscn")
@export var start_level: int = 1

func _on_pressed():
    LevelManager.current_level = start_level
    get_tree().change_scene_to_packed(game_scene)
    SoundFx.play_select_sfx()
