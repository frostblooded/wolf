class_name FactUI
extends HBoxContainer

func initialize(fact: Fact):
    $Label.text = fact.name
    $TextureRect.texture = fact.image

func initialize_with_additional_text(fact: Fact, text: String):
    $Label.text = fact.name + text
    $TextureRect.texture = fact.image
