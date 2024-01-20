extends Button

var game_scene: PackedScene = load("res://scenes/Main.tscn")
@export var start_difficulty: DifficultyManager.Difficulty = DifficultyManager.Difficulty.NORMAL

func _on_pressed():
    DifficultyManager.current_difficulty = start_difficulty
    get_tree().change_scene_to_packed(game_scene)
    SoundFx.play_select_sfx()
