class_name TraitUI
extends HBoxContainer

func initialize(t: Trait):
    $Label.text = t.name
    $TextureRect.texture = t.image
