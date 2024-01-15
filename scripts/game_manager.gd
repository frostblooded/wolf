extends Node2D

@export var unit_ui_scene: PackedScene = null
@export var possible_positive_traits: Array[Trait] = []
@export var possible_negative_traits: Array[Trait] = []

@onready var round_result_panel_shower: CanvasLayer = get_parent().find_child("RoundResultLayer")

var current_unit: Unit = null
var current_unit_ui: BlessingUnitUI = null

func _ready():
    randomize()
    show_unit()
    MessageBus.ROUND_END.connect(on_unit_blessing_done)
    MessageBus.BLESS_BUTTON_PRESSED.connect(on_bless_button_pressed)

func on_bless_button_pressed(bless_amount: int):
    var total_strength: float = current_unit.strength
    var bless_multiplier: float = 1

    for t in current_unit.positive_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    for t in current_unit.negative_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    total_strength += bless_amount * bless_multiplier

    var won: bool = total_strength >= 90 and total_strength < 100
    round_result_panel_shower.show_bless_results(current_unit, bless_amount, total_strength, won)
    current_unit_ui.hide()

func on_unit_blessing_done():
    current_unit_ui.queue_free()
    current_unit = null
    show_unit()

func show_unit():
    current_unit_ui = unit_ui_scene.instantiate() as BlessingUnitUI
    current_unit = generate_unit()
    current_unit_ui.initialize(current_unit)
    get_parent().get_node("BlessingUnitUIHolder").add_child.call_deferred(current_unit_ui)

func generate_unit() -> Unit:
    var unit: Unit = Unit.new()
    unit.strength = randi_range(0, 80)

    var MIN_TRAITS: int = 1
    var MAX_TRAITS: int = 3
    assert(MIN_TRAITS <= MAX_TRAITS);
    assert(possible_positive_traits.size() >= MAX_TRAITS);
    assert(possible_negative_traits.size() >= MAX_TRAITS);

    var positive_traits_amount: int = randi_range(MIN_TRAITS, MAX_TRAITS)
    var positive_traits_shuffled_copy: Array[Trait] = possible_positive_traits
    positive_traits_shuffled_copy.shuffle()

    for i in range(0, positive_traits_amount):
        unit.positive_traits.push_back(positive_traits_shuffled_copy[i])

    var negative_traits_amount: int = randi_range(MIN_TRAITS, MAX_TRAITS)
    var negative_traits_shuffled_copy: Array[Trait] = possible_negative_traits
    negative_traits_shuffled_copy.shuffle()

    for i in range(0, negative_traits_amount):
        unit.negative_traits.push_back(negative_traits_shuffled_copy[i])

    return unit
