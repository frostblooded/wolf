extends Node2D

@export var unit_ui_scene: PackedScene = null
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

func on_bless_button_pressed(context: BlessContext):
    var won: bool = false
    var total_strength: float = 0

    if current_unit.type == null:
        won = current_unit.anomaly.is_complete(context)
    else:
        total_strength = context.bless_amount

        if current_unit.type != null:
            total_strength *= current_unit.type.multiplier

        for fact in current_unit.facts:
            total_strength += fact.value

        var min_goal: int = LevelManager.get_min_goal()
        won = total_strength >= min_goal and total_strength <= 100

    handle_win_streak(won)
    var is_game_end: bool = win_streak == required_victory_streak_for_game_win

    if is_game_end:        
        SoundFx.play_game_win_sfx()
    elif won:
        SoundFx.play_success_sfx()
    else:
        SoundFx.play_fail_sfx()        

    round_result_panel_shower.show_bless_results(current_unit, context.bless_amount, total_strength, won, is_game_end)
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
    current_unit_ui.initialize(current_unit, win_streak)
    get_parent().get_node("BlessingUnitUIHolder").add_child.call_deferred(current_unit_ui)

func generate_unit() -> Unit:
    var unit: Unit = Unit.new()

    var possible_unit_types: Array = LevelManager.get_possible_unit_types()

    if !possible_unit_types.is_empty():
        unit.type = possible_unit_types.pick_random()

    unit.anomaly = LevelManager.get_anomaly(win_streak)

    var possible_facts = LevelManager.get_possible_facts()
    var facts_count: int = LevelManager.get_facts_count()
    assert(possible_facts.size() >= facts_count);

    var facts_shuffled_copy = possible_facts
    facts_shuffled_copy.shuffle()

    for i in range(0, facts_count):
        unit.facts.push_back(facts_shuffled_copy[i])

    return unit
