class_name BlessingUnitUI
extends CanvasLayer

@export var trait_ui_scene: PackedScene = null
var unit: Unit = null

func _ready():
    MessageBus.BLESS_BUTTON_PRESSED.connect(on_bless_button_pressed)

func on_bless_button_pressed(bless_amount: int):
    var total_strength: float = unit.strength
    var bless_multiplier: float = 1

    for t in unit.positive_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    for t in unit.negative_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    total_strength += bless_amount * bless_multiplier

    var unit_image_ui: UnitImageUI = find_child("UnitImageUI")
    unit_image_ui.show_animated_bless_results(unit, bless_amount, total_strength)

func initialize(u: Unit):
    self.unit = u

    var current_strength_label: Label = find_child("CurrentStrengthLabel")
    current_strength_label.text = "Base strength: %d" % unit.strength

    var positive_traits_container: Control = find_child("PositiveTraitsContainer")
    var negative_traits_container: Control = find_child("NegativeTraitsContainer")

    for positive_trait in u.positive_traits:
        var trait_ui: Node = trait_ui_scene.instantiate()
        trait_ui.initialize(positive_trait)
        positive_traits_container.add_child(trait_ui)

    for negative_trait in u.negative_traits:
        var trait_ui: Node = trait_ui_scene.instantiate()
        trait_ui.initialize(negative_trait)
        negative_traits_container.add_child(trait_ui)
