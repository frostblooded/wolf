class_name UnitTypeUI
extends Control

func initialize(unit_type: UnitType):
    $Label.text = unit_type.name
    $TextureRect.texture = unit_type.image

func initialize_with_additional_text(unit_type: UnitType, text: String):
    $Label.text = unit_type.name + text
    $TextureRect.texture = unit_type.image
