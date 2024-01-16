extends Button

var game_scene: PackedScene = load("res://scenes/Main.tscn")

func _on_pressed():
    get_tree().change_scene_to_packed(game_scene)
