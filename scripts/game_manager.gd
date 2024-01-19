extends Node2D

@export var unit_ui_scene: PackedScene = null
@export var possible_facts: Array[Fact] = []
@export var possible_unit_types: Array[UnitType] = []
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
    var total_strength: float = bless_amount
    total_strength *= current_unit.type.multiplier

    for fact in current_unit.facts:
        total_strength += fact.value

    var min_goal: int = DifficultyManager.get_min_goal()
    var won: bool = total_strength >= min_goal and total_strength <= 100
    handle_win_streak(won)
    var is_game_end: bool = win_streak == required_victory_streak_for_game_win
    round_result_panel_shower.show_bless_results(current_unit, bless_amount, total_strength, won, is_game_end)
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

    assert(!possible_unit_types.is_empty());
    unit.type = possible_unit_types.pick_random()

    var MIN_FACTS: int = 1
    var max_facts: int = DifficultyManager.get_max_facts()
    assert(MIN_FACTS <= max_facts);
    assert(possible_facts.size() >= max_facts);

    var facts_amount: int = randi_range(MIN_FACTS, max_facts)
    var facts_shuffled_copy: Array[Fact] = possible_facts
    facts_shuffled_copy.shuffle()

    for i in range(0, facts_amount):
        unit.facts.push_back(facts_shuffled_copy[i])

    return unit
