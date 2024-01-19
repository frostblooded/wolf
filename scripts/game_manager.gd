extends Node2D

@export var unit_ui_scene: PackedScene = null
@export var possible_positive_traits: Array[Trait] = []
@export var possible_negative_traits: Array[Trait] = []
@export var required_victory_streak_for_game_win: int = 3

@onready var round_result_panel_shower: CanvasLayer = get_parent().find_child("RoundResultLayer")

var current_unit: Unit = null
var current_unit_ui: BlessingUnitUI = null
var win_streak: int = 0
var main_menu_scene: PackedScene = load("res://scenes/MainMenu.tscn")

func _ready():
    randomize()
    show_unit()
    MessageBus.ROUND_END.connect(on_round_end)
    MessageBus.GAME_END.connect(on_game_end)
    MessageBus.BLESS_BUTTON_PRESSED.connect(on_bless_button_pressed)

func on_bless_button_pressed(bless_amount: int):
    var total_strength: float = 0
    var bless_multiplier: float = 1

    for t in current_unit.positive_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    for t in current_unit.negative_traits:
        bless_multiplier *= t.mul_modifier
        total_strength += t.add_modifier

    total_strength += bless_amount * bless_multiplier

    var min_goal: int = DifficultyManager.get_min_goal()
    var won: bool = total_strength >= min_goal and total_strength <= 100
    handle_win_streak(won)
    var is_game_end: bool = win_streak == required_victory_streak_for_game_win
    round_result_panel_shower.show_bless_results(current_unit, bless_amount, total_strength, won, is_game_end, win_streak)
    current_unit_ui.hide()

func handle_win_streak(won: bool):
    if won:
        win_streak += 1
    else:
        win_streak = 0

func on_game_end():
    get_tree().change_scene_to_packed(main_menu_scene)

func on_round_end():
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

    var MIN_TRAITS: int = 1
    var max_traits: int = DifficultyManager.get_max_traits()
    assert(MIN_TRAITS <= max_traits);
    assert(possible_positive_traits.size() >= max_traits);
    assert(possible_negative_traits.size() >= max_traits);

    var positive_traits_amount: int = randi_range(MIN_TRAITS, max_traits)
    var positive_traits_shuffled_copy: Array[Trait] = possible_positive_traits
    positive_traits_shuffled_copy.shuffle()

    for i in range(0, positive_traits_amount):
        unit.positive_traits.push_back(positive_traits_shuffled_copy[i])

    var negative_traits_amount: int = randi_range(MIN_TRAITS, max_traits)
    var negative_traits_shuffled_copy: Array[Trait] = possible_negative_traits
    negative_traits_shuffled_copy.shuffle()

    for i in range(0, negative_traits_amount):
        unit.negative_traits.push_back(negative_traits_shuffled_copy[i])

    return unit
