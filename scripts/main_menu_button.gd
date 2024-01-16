extends Button

var main_menu_scene: PackedScene = load("res://scenes/MainMenu.tscn")

func _on_pressed():
    get_tree().change_scene_to_packed(main_menu_scene)
