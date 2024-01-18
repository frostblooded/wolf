class_name TraitUI
extends HBoxContainer

func initialize(t: Trait):
    $Label.text = t.name
    $TextureRect.texture = t.image

func initialize_with_additional_text(t: Trait, text: String):
    $Label.text = t.name + text
    $TextureRect.texture = t.image
