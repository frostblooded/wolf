class_name BlessingUnitUI
extends CanvasLayer

@export var trait_ui_scene: PackedScene = null

@onready var bless_amount_slider = find_child("BlessAmountSlider")

func initialize(unit: Unit):
    var current_strength_label: Label = find_child("CurrentStrengthLabel")
    current_strength_label.text = "Base strength: %d" % unit.strength

    var positive_traits_container: Control = find_child("PositiveTraitsContainer")
    var negative_traits_container: Control = find_child("NegativeTraitsContainer")

    for positive_trait in unit.positive_traits:
        var trait_ui: Node = trait_ui_scene.instantiate()
        trait_ui.initialize(positive_trait)
        positive_traits_container.add_child(trait_ui)

    for negative_trait in unit.negative_traits:
        var trait_ui: Node = trait_ui_scene.instantiate()
        trait_ui.initialize(negative_trait)
        negative_traits_container.add_child(trait_ui)
